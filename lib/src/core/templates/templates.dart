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
            "name": "Carls",
            "email": "carls@gmail.com",
            "password": "1234"
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

# storage:
#   folder: storage/
#   name: "file"

# auth:
#   key: dajdi3cdj8jw40jv89cj4uybfg9wh9vcnvb
#   exp: 3600
#   scape:
#     - storage
#     - file
''';