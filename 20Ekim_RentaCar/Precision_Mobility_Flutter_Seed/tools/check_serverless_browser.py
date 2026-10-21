"""Real Chromium/stdlib smoke test of the built app, with business APIs blocked."""
import functools
import json
import os
import shutil
import subprocess
import tempfile
import threading
import time
import urllib.request
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from browser_driver import CDP


class StaticAssets(SimpleHTTPRequestHandler):
    def log_message(self, *_):
        pass


def check(cdp, text):
    assert cdp.contains(text), 'Missing visible/accessible content: ' + text


def journey(cdp, url):
    cdp.call('Page.enable')
    cdp.call('Page.bringToFront')
    cdp.call('Runtime.enable')
    cdp.call('Network.enable')
    cdp.call('Network.setBlockedURLs', {'urls': ['*://*/api/*', '*://*:8765/*', 'https://*']})
    cdp.call('Emulation.setDeviceMetricsOverride', {'width': 390, 'height': 1050,
        'deviceScaleFactor': 1, 'mobile': True})
    cdp.call('Page.navigate', {'url': url})
    cdp.ready()
    check(cdp, 'Renault Clio')
    assert not cdp.contains('Çalışma alanı')
    assert not cdp.contains('Sunucuya')
    cdp.click('Favorilere ekle')
    assert cdp.snapshot()['favorites'] == ['clio']
    cdp.click('Favoriler')
    cdp.click('Aracı incele')
    cdp.click('Rezervasyon oluştur')
    cdp.click('Rezervasyonu kaydet')
    check(cdp, 'Rezervasyonunuz kaydedildi.')
    cdp.capture('serverless-saved-receipt')
    saved = cdp.snapshot()
    assert len(saved['plans']) == 1
    assert saved['plans'][0]['total'] == 290000
    reference = saved['plans'][0]['id']
    cdp.click('Rezervasyonlarımı gör')
    check(cdp, 'Cihazda kayıtlı')
    cdp.click('Profil')
    cdp.click('Koyu')
    assert cdp.snapshot()['theme'] == 'dark'
    cdp.call('Page.reload')
    cdp.ready()
    assert cdp.snapshot()['plans'][0]['id'] == reference
    assert cdp.snapshot()['theme'] == 'dark'
    cdp.click('Planlarım')
    check(cdp, 'Renault Clio')
    for width, size in [(390, 'mobile'), (1440, 'desktop')]:
        cdp.call('Emulation.setDeviceMetricsOverride', {'width': width, 'height': 1050,
            'deviceScaleFactor': 1, 'mobile': width < 1000})
        for theme in ['Açık', 'Koyu']:
            cdp.click('Profil')
            cdp.click(theme)
            for menu, suffix, text in [('Keşfet', 'catalog', 'Renault Clio'),
                    ('Favoriler', 'favorites', 'Renault Clio'),
                    ('Planlarım', 'plans', 'Cihazda kayıtlı'),
                    ('Profil', 'profile', 'Tercihleriniz')]:
                cdp.click(menu)
                check(cdp, text)
                cdp.capture(f'serverless-{size}-{theme}-{suffix}')
    # After loading the static app assets, all product actions still work offline.
    cdp.call('Network.emulateNetworkConditions', {'offline': True, 'latency': 0,
        'downloadThroughput': 0, 'uploadThroughput': 0})
    cdp.click('Planlarım')
    cdp.click('Rezervasyonu iptal et')
    cdp.click('Evet, iptal et')
    assert cdp.snapshot()['plans'][0]['cancelled'] is True
    check(cdp, 'İptal edildi')
    cdp.click('Favoriler')
    check(cdp, 'Renault Clio')
    cdp.click('Profil')
    check(cdp, 'Tercihleriniz')
    cdp.call('Network.emulateNetworkConditions', {'offline': False, 'latency': 0,
        'downloadThroughput': -1, 'uploadThroughput': -1})
    cdp.call('Page.reload')
    cdp.ready()
    assert cdp.snapshot()['plans'][0]['cancelled'] is True
    assert not cdp.errors, cdp.errors
    external = [u for u in cdp.requests if u.startswith(('http:', 'https:')) and not u.startswith(url)]
    assert not external, external
    assert not any('/api/' in u or ':8765/' in u for u in cdp.requests)
    print('PASS: real browser, zero API/external requests; favorite/reserve/reload/theme/offline cancel/reload.', flush=True)


def main():
    root = Path(__file__).resolve().parents[1]
    assert (root / 'build/web/main.dart.js').exists(), 'Build web with --no-web-resources-cdn first.'
    chrome = os.environ.get('PRECISION_CHROME') or shutil.which('google-chrome') or shutil.which('chromium')
    if not chrome:
        chrome = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
    server = ThreadingHTTPServer(('127.0.0.1', 0),
        functools.partial(StaticAssets, directory=str(root / 'build/web')))
    thread = threading.Thread(target=server.serve_forever, daemon=True)
    thread.start()
    try:
        with tempfile.TemporaryDirectory(prefix='precision-serverless-browser-') as profile:
            browser = subprocess.Popen([chrome, '--headless=new', '--no-first-run',
                '--no-default-browser-check', '--disable-background-networking',
                '--remote-debugging-port=0', '--remote-allow-origins=*',
                '--user-data-dir=' + profile, '--enable-unsafe-swiftshader', 'about:blank'],
                stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            try:
                port_file = Path(profile) / 'DevToolsActivePort'
                for _ in range(100):
                    if port_file.exists():
                        break
                    time.sleep(.1)
                port = int(port_file.read_text().splitlines()[0])
                target = json.load(urllib.request.urlopen(urllib.request.Request(
                    f'http://127.0.0.1:{port}/json/new?about:blank', method='PUT')))
                cdp = CDP(target['webSocketDebuggerUrl'])
                try:
                    journey(cdp, f'http://127.0.0.1:{server.server_port}/')
                except Exception:
                    cdp.capture('serverless-failure')
                    print({'js_errors': cdp.errors, 'requests': cdp.requests[-15:],
                        'text': cdp.evaluate('document.body.innerText')[:1400]}, flush=True)
                    raise
                finally:
                    cdp.sock.close()
            finally:
                browser.terminate()
                browser.wait(timeout=10)
    finally:
        server.shutdown()
        server.server_close()
        thread.join(timeout=2)


if __name__ == '__main__':
    main()
