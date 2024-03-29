enum TemplateType {
  database(_database),
  config(_config);

  final String templateBody;

  const TemplateType(this.templateBody);
}

const String _database = r'''
{
    "users": [
        {
            "id": 0,
            "name": "Rodrigo Rahman",
            "email": "rodrigorahman@academiadoflutter.com.br",
            "password": "123"
        },
        {
            "id": 1,
            "name": "Guilherme",
            "email": "guilherme@gmail.com",
            "password": "1234"
        }
    ],
    "adm_users": [
        {
            "id": 1,
            "name": "Rodrigo Rahman",
            "email": "rodrigorahman@academiadoflutter.com.br",
            "password": "123",
            "profile": "ADMIN"
        },
        {
            "id": 2,
            "name": "Guilherme",
            "email": "Guilherme@gmail.com",
            "password": "1234",
            "profile": "SUPORTE"
        }
    ],
    "products": [
        {
            "id": 0,
            "title": "Academia do flutter"
        },
        {
            "id": 1,
            "title": "Jornada Dart"
        },
        {
            "id": 2,
            "title": "Jornada GetX"
        }
    ]
}
''';

const _config = r'''
name: Json Rest Server
port: 8080
host: 0.0.0.0
database: database.json

# auth:
#   jwtSecret: cwsMXDtuP447WZQ63nM4dWZ3RppyMl
#   jwtExpire: 3600
#   unauthorizedStatusCode: 403
#   urlSkip:
#     - /images/:
#        method: get
#     - /users:
#        method: post
#      - /products/{*}:
#        method: get
''';
