# a TODO collaboration tool with friends

## development
* install serverpod [see quickstart](https://docs.serverpod.dev/quickstart?utm_source=builderbase&utm_medium=event&utm_campaign=hackathon_serverpod_4_26&utm_content=quickstart): `dart install serverpod_cli`
* run project: start server: `serverpod start`
* When using [serverpod_embedded_postgres](https://pub.dev/packages/serverpod_embedded_postgres): `serverpod start`, Serverpod manages a standalone Postgres instance directly without Docker.   To connect using psql, you need two key parameters from your project files:
  * Port, User, and Database Name: Found in `config/development.yaml` 
  * Password: Found in `config/passwords.yaml` 
or start postgres separatelly and see the connection string: `serverpod database start`

* [working with endpoints](https://docs.serverpod.dev/3.1.0/concepts/working-with-endpoints)
* [Accessing Google APIs server-side from a Flutter app](https://serverpod.dev/blog/flutter-google-apis-server-side)
