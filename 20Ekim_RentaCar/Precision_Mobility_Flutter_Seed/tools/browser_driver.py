import base64
import json
import os
import socket
import struct
import time
from pathlib import Path


class CDP:
    def __init__(self, url):
        from urllib.parse import urlparse
        endpoint = urlparse(url)
        self.sock = socket.create_connection((endpoint.hostname, endpoint.port), timeout=15)
        key = base64.b64encode(os.urandom(16)).decode()
        self.sock.sendall((f'GET {endpoint.path} HTTP/1.1\r\nHost: {endpoint.hostname}:{endpoint.port}\r\n'
            f'Upgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Key: {key}\r\n'
            'Sec-WebSocket-Version: 13\r\nOrigin: http://localhost\r\n\r\n').encode())
        header = b''
        while not header.endswith(b'\r\n\r\n'):
            header += self.sock.recv(1)
        assert b' 101 ' in header.split(b'\r\n')[0], header.split(b'\r\n')[0]
        self.identity = 0
        self.errors = []
        self.requests = []

    def send(self, data, opcode=1):
        raw = data.encode() if isinstance(data, str) else data
        length = len(raw)
        header = bytes([128 | opcode])
        if length < 126:
            header += bytes([128 | length])
        elif length < 65536:
            header += bytes([128 | 126]) + struct.pack('!H', length)
        else:
            header += bytes([128 | 127]) + struct.pack('!Q', length)
        mask = os.urandom(4)
        self.sock.sendall(header + mask + bytes(value ^ mask[i % 4] for i, value in enumerate(raw)))

    def read(self, length):
        result = b''
        while len(result) < length:
            part = self.sock.recv(length - len(result))
            if not part:
                raise EOFError()
            result += part
        return result

    def call(self, method, params=None):
        self.identity += 1
        self.send(json.dumps({'id': self.identity, 'method': method, 'params': params or {}}))
        fragments = b''
        while True:
            first, second = self.read(2)
            length = second & 127
            if length == 126:
                length = struct.unpack('!H', self.read(2))[0]
            elif length == 127:
                length = struct.unpack('!Q', self.read(8))[0]
            payload = self.read(length)
            if first & 15 == 9:
                self.send(payload, 10)
                continue
            fragments += payload
            if not first & 128:
                continue
            event = json.loads(fragments)
            fragments = b''
            if event.get('method') == 'Network.requestWillBeSent':
                self.requests.append(event['params']['request']['url'])
            if event.get('method') == 'Runtime.exceptionThrown':
                self.errors.append(event['params']['exceptionDetails'].get('text', 'JavaScript exception'))
            if event.get('method') == 'Runtime.consoleAPICalled' and event['params']['type'] == 'error':
                self.errors.append(' '.join(str(a.get('value', a.get('description', '')))
                    for a in event['params']['args'])[:1400])
            if event.get('id') == self.identity:
                if 'error' in event:
                    raise RuntimeError(event['error'])
                return event.get('result', {})

    def evaluate(self, expression):
        result = self.call('Runtime.evaluate', {'expression': expression,
            'returnByValue': True, 'awaitPromise': True})
        if 'exceptionDetails' in result:
            raise RuntimeError(result['exceptionDetails']['text'])
        return result.get('result', {}).get('value')

    def capture(self, name):
        result = self.call('Page.captureScreenshot', {'format': 'png'})
        path = Path('/tmp') / f'precision-populated-{name}.png'
        path.write_bytes(base64.b64decode(result['data']))
        print('Captured:', path, flush=True)

    def click(self, label):
        expression = """(()=>{const label=""" + json.dumps(label) + """;
            const all=Array.from(document.querySelectorAll('flt-semantics'));
            const e=all.find(e=>['button','tab','checkbox','radio'].includes(e.getAttribute('role')) &&
              (e.getAttribute('aria-label')===label || e.innerText.trim()===label));
            if(!e)return null;
            const r=e.getBoundingClientRect();return {x:r.x+r.width/2,y:r.y+r.height/2};})()"""
        for _ in range(20):
            target = self.evaluate(expression)
            if not target:
                raise AssertionError('Control missing: ' + label)
            height = self.evaluate('innerHeight')
            if 80 < target['y'] < height - 20:
                break
            self.call('Input.dispatchMouseEvent', {'type': 'mouseWheel',
                'x': self.evaluate('innerWidth/2'), 'y': height / 2,
                'deltaX': 0, 'deltaY': max(-700, min(700, target['y'] - height / 2))})
            time.sleep(.12)
        time.sleep(.25)
        target = self.evaluate(expression)
        # Activate the exposed accessibility control, not its scroll/group box.
        self.evaluate("""(()=>{const label=""" + json.dumps(label) + """;
            const e=Array.from(document.querySelectorAll('flt-semantics')).find(e=>
              ['button','tab','checkbox','radio'].includes(e.getAttribute('role')) &&
              (e.getAttribute('aria-label')===label || e.innerText.trim()===label));
            if(!e)throw Error('Control missing: '+label);e.click();})()""")
        time.sleep(.8)

    def ready(self):
        for _ in range(120):
            self.evaluate("document.querySelector('flt-semantics-placeholder')?.click()")
            if self.contains('Renault Clio'):
                return
            time.sleep(.2)
        raise AssertionError('Application did not become ready')

    def snapshot(self):
        return self.evaluate("""(()=>{const k=Object.keys(localStorage).find(k=>k.includes('precision.renter.v1'));
            if(!k)return null;let v=JSON.parse(localStorage.getItem(k));
            return typeof v==='string'?JSON.parse(v):v;})()""")

    def contains(self, text):
        return self.evaluate("Array.from(document.querySelectorAll('flt-semantics')).some(e=>(e.innerText+' '+e.getAttribute('aria-label')).includes(" + json.dumps(text) + "))")

