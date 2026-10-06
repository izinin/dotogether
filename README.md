# a TODO collaboration tool with friends

## deployment
* deploy: `scloud launch`
* check urls: `scloud domain list`
* Serverpod Cloud project ID is: `dotogether`
When the server has started, you can access it at:
   Web:      https://dotogether.serverpod.space/
   API:      https://dotogether.api.serverpod.space/
   Insights: https://dotogether.insights.serverpod.space/
* to see how to view deployment statuses, run this command: `scloud help status`
* generating icons for client apps: `cd dotogether_flutter && dart run flutter_launcher_icons`

## development
* install serverpod [see quickstart](https://docs.serverpod.dev/quickstart?utm_source=builderbase&utm_medium=event&utm_campaign=hackathon_serverpod_4_26&utm_content=quickstart): `dart install serverpod_cli`
* run project: start server: `serverpod start`
* When using [serverpod_embedded_postgres](https://pub.dev/packages/serverpod_embedded_postgres): `serverpod start`, Serverpod manages a standalone Postgres instance directly without Docker.   To connect using psql, you need two key parameters from your project files:
  * Port, User, and Database Name: Found in `config/development.yaml` 
  * Password: Found in `config/passwords.yaml` 
or start postgres separatelly and see the connection string: `serverpod database start`

### connect physical device on macos in the same WiFi
* find local IP in the WiFi: `ipconfig getifaddr en0`
* update Serverpod's `dotogether_server/config/development.yaml` `publicHost: localhost` to `publicHost: 10.66.11.24`
* start Postgres separately: `serverpod database start`
* start serverpod: `serverpod start --no-flutter`
* start the app: `flutter run -d 00008030-001059C01AEA402E --dart-define SERVER_URL=http://10.66.11.24:8080/`

### Google OAuth2
* [Authentication setup](https://docs.serverpod.dev/next/concepts/authentication/providers/google/setup)
* [Webapp auth callback route](https://docs.serverpod.dev/next/concepts/authentication/setup#web-callback-page-authhtml)
* [runnning web in local dev](https://docs.serverpod.dev/next/concepts/authentication/providers/google/setup#web):
* run web targed locally with making the same origin with serverpod
```shell
flutter build web --base-href / --output ../dotogether_server/web/app  # from your Flutter project
serverpod start --no-flutter                                           # from your server project
```

### using Firebase Auth
* creating application with CLI: `flutterfire configure`

* Example [Accessing Google APIs server-side from a Flutter app](https://serverpod.dev/blog/flutter-google-apis-server-side)

### migrating database
* Regenerate code: `serverpod generate`
* Create fresh migration:  `serverpod create-migration`
* apply migration: `dart bin/main.dart --apply-migrations`

### Understanding API Server vs Web Server
* API Server (apiServer - Default: Port `8080`): Handles Flutter client communication using WebSockets (for streaming/subscriptions) and HTTP RPC requests (for standard endpoint method calls).

* Web Server (webServer - Default: Port `8082`): Handles standard HTTP requests. This serves static web content, HTML web pages, and incoming OAuth redirect callbacks from external web browsers (like Google or Apple).

#### Adding Custom HTTP Handlers/Routes to the Web Server
* In `Serverpod`, custom HTTP endpoints for the `webServer` are created by extending WidgetRoute (for HTML pages) or Route (for JSON/raw HTTP responses), and then adding them to `pod.webServer`.


### Flutter UI 

![alt text](image.png)