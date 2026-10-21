# Precision Mobility

Flutter application with an editorial automotive interface and a working local
SQLite/HTTP workspace. The default entrypoint opens a labelled, populated example workspace on the real
SQLite API. Private operational records stay in their separate existing database.

## Run

Terminal 1, from this directory:

```sh
python3 -m server
```

Terminal 2:

```sh
flutter pub get
flutter run -d web-server --web-hostname localhost --web-port 8080
```

Open http://localhost:8080. The example workspace opens automatically with ten
fictional vehicles, six reservations and a calendar block. All actions use the
server and changes persist; examples are not regenerated on restart. Eight
vehicles are published; one is in maintenance and one is unpublished.

For your private workspace, in Hesabım enter the contents of `.local/operator.key`
and choose Çalışma alanına bağlan. The server creates this
private key only when missing; existing records and the key are preserved.
Use Araçlar → Araç ekle to enter your own vehicles.

## Interface and flows

- New desktop top navigation and mobile floating dock.
- Editorial discovery hero, search/date panel, ownership filters and actual price sorting.
- Own listing photos or missing-photo states; labelled artwork for fictional examples only.
- Inventory metrics, desktop management table/mobile cards, editing, publication and date blocks.
- Grouped vehicle form, decimal-to-integer money validation and fixed save action.
- Server quotes before confirmation; signed five-minute offers, price-change checks and atomic availability.
- Reservation cards, active/cancelled filters and cancellation confirmation.
- Example/private workspace switching, actual record overview, themes and contextual help.

The AI-generated hero is a decorative concept photograph, labelled as such and
never attached to an inventory vehicle. [Asset provenance](docs/design/asset-provenance.md).

## Data and service scope

`.local/mobility.sqlite3` holds vehicle/reservation records, including cancelled
history. `.local/operator.key` controls this local workspace; the client keeps it
only in memory. `.local/examples.sqlite3` holds the separate fictional collection.
Its scoped access cannot read/write the private workspace. `.local/quotes.key` is
a server-only quote signing secret, never sent to Flutter. `.local/` is ignored
by Git; existing private records/key are preserved. No examples enter the private DB.

The user deferred identity/payment providers. Customer accounts/verification,
payment collection/refunds, actual inspection evidence, vehicle handover/hardware
and a secured public multi-user deployment are not implemented by this UI task.
No customer identity, card or GPS data is collected. A reservation record is not
a signed rental agreement. [Server contract](server/README.md).

## Configuration and platforms

The API defaults to `http://127.0.0.1:8765/api/v1/`. An explicitly configured API can
use `--dart-define=PRECISION_API_URL=https://your-server/api/v1/`. Android emulator
development may use `http://10.0.2.2:8765/api/v1/`; cleartext exceptions are debug-only
and limited to local hosts. To start directly with the private catalog, add
`--dart-define=PRECISION_EXAMPLES=false`. Native platform runners and network permissions are
retained. Native runtime/signing and physical devices are not verified here.

## Verify

```sh
flutter analyze
flutter test
python3 -m unittest discover -s server -t . -v
dart run tools/check_local_api.dart
python3 tools/quality_gate.py
flutter build web --release
```

The real HTTP check uses isolated temporary state and never touches `.local`.
Authored text files stay <=300 lines. CI includes backend/HTTP checks.
The historical simulation is explicitly available via `flutter run -t lib/main_demo.dart`.
Current evidence and changed files: [TASK-013](docs/verification/TASK-013.md).
Requirement map and deferred integrations: [requirements](docs/product/requirements-status.md).
