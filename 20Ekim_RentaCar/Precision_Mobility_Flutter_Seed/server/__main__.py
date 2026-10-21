import argparse
import os
import secrets
from pathlib import Path
from .database import Database
from .http_server import Server
from .examples import initialize_examples


def secret_file(path):
    if not path.exists():
        fd = os.open(path, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
        with os.fdopen(fd, 'w') as stream:
            stream.write(secrets.token_urlsafe(32))
    return path.read_text().strip()


def main():
    parser = argparse.ArgumentParser(description='Precision local workspace')
    parser.add_argument('--port', type=int, default=8765)
    parser.add_argument('--state-dir', type=Path, default=Path('.local'))
    parser.add_argument('--web-origin', default='http://localhost:8080')
    args = parser.parse_args()
    args.state_dir.mkdir(parents=True, exist_ok=True, mode=0o700)
    key_path = args.state_dir / 'operator.key'
    operator_key = secret_file(key_path)
    server = Server(('127.0.0.1', args.port), Database(args.state_dir / 'mobility.sqlite3'),
                    operator_key, args.web_origin,
                    examples=initialize_examples(args.state_dir / 'examples.sqlite3'),
                    quote_secret=secret_file(args.state_dir / 'quotes.key'))
    print(f'Precision local API: http://127.0.0.1:{server.server_port}/api/v1', flush=True)
    print(f'Workspace key file: {key_path} (key is not logged)', flush=True)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()


if __name__ == '__main__':
    main()
