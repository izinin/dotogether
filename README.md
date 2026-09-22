# a TODO collaboration tool with friends

## development
* install serverpod [see quickstart](https://docs.serverpod.dev/quickstart?utm_source=builderbase&utm_medium=event&utm_campaign=hackathon_serverpod_4_26&utm_content=quickstart): `dart install serverpod_cli`
* run project: start server: `serverpod start`
* When using [serverpod_embedded_postgres](https://pub.dev/packages/serverpod_embedded_postgres): `serverpod start`, Serverpod manages a standalone Postgres instance directly without Docker.   To connect using psql, you need two key parameters from your project files:
  * Port, User, and Database Name: Found in `config/development.yaml` 
  * Password: Found in `config/passwords.yaml` 
or start postgres separatelly and see the connection string: `serverpod database start`

### Google OAuth2
* [Authentication setup](https://docs.serverpod.dev/next/concepts/authentication/providers/google/setup)
* [Webapp auth callback route](https://docs.serverpod.dev/next/concepts/authentication/setup#web-callback-page-authhtml)
* [runnning web in local dev](https://docs.serverpod.dev/next/concepts/authentication/providers/google/setup#web):
* run web targed locally with making the same origin with serverpod
```shell
flutter build web --base-href / --output ../dotogether_server/web/app  # from your Flutter project
serverpod start --no-flutter                                           # from your server project
```


* Example [Accessing Google APIs server-side from a Flutter app](https://serverpod.dev/blog/flutter-google-apis-server-side)
* Obsolete [working with endpoints](https://docs.serverpod.dev/3.1.0/concepts/working-with-endpoints)


### Understanding API Server vs Web Server
* API Server (apiServer - Default: Port `8080`): Handles Flutter client communication using WebSockets (for streaming/subscriptions) and HTTP RPC requests (for standard endpoint method calls).

* Web Server (webServer - Default: Port `8082`): Handles standard HTTP requests. This serves static web content, HTML web pages, and incoming OAuth redirect callbacks from external web browsers (like Google or Apple).

#### Adding Custom HTTP Handlers/Routes to the Web Server
* In `Serverpod`, custom HTTP endpoints for the `webServer` are created by extending WidgetRoute (for HTML pages) or Route (for JSON/raw HTTP responses), and then adding them to `pod.webServer`.