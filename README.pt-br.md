Json Rest Server is a RESTful server based on JSON
<div align="center">

**Languages:**

[![Portuguese](https://img.shields.io/badge/Language-Portuguese-red?style=for-the-badge)](README.pt-br.md)
[![English](https://img.shields.io/badge/Language-English-red?style=for-the-badge)](README.en.md)</div>

# Json Rest Server 

Um RESTful server baseado em JSON

Tenha um servidor restfull 100% funcional com autenticação, paginação e todos os serviços necessários para desenvolvimento de aplicações

## Instalação
1. Faça a instalação do Dart (https://dart.dev/get-dart
). Lembrando que se você tem o Flutter instalado você não precisa fazer a instalação do Dart

2. Ative o Json Rest Server pelo pub
```
dart pub global activate json_rest_server
```

## Configurações

No arquivo config.yaml ficam as configurações do servidor

Segue descrição dos parametros:

```
name -> Nome do seu servidor
port -> porta de acesso
host -> Ip de acesso, caso queira que responda por ip e localhost coloque 0.0.0.0
database -> nome do arquivo do seu banco de dados
```

## Comandos

**ATENÇÃO**: 
O executável padrão do projeto é json_rest_server porém você também pode utilizar **jsonRestServer** ou somente **jrs** facilitando assim a digitação ;-)

**Atualizando**:

Atualizando versão do Json Rest Server:

```
json_rest_server upgrade
```

**Criando projeto**

Os comando abaixo criarão toda a configuração necessária para rodar seu servidor

Em uma pasta vazia execute o comando
```
json_rest_server create
```

Caso queira que o Json Rest Server crie a pasta execute
```
json_rest_server create ./nome_pasta
```

**Iniciando Servidor**

O comando abaixo rodará o servidor basedo nas configurações que estão no arquivo config.yaml

Entre na pasta onde você executou o comando create e execute
```
json_rest_server run
```

## Rotas

Quando rodamos o Json Rest Server será criado as rotas baseado no conceito RESTful basedo no arquivo database.json

Cada chave criada nesse arquivo terá suas rotas completas ex:

```
 {
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
```

**Teremos as rotas**:

```
GET    /products                     -> Recuperar todos os produtos
GET    /products?page=1&limit=10     -> Recuperar todos os produtos paginado
GET    /products/1                   -> Recuperar 1 produto
POST   /products                     -> Adicionar um produto
PUT    /products/1                   -> Editar um produto
PATCH  /products/1                   -> Editar um produto
DELETE /products/1                   -> Deletar um produto
```

**OBS: Lembre que os método post, put e patch devem conter um body json**

Na pasta exemplos existe um arquivo postman com todos os exemplos mencionados acima


## Autenticação

Json Rest Server já vem com todo o processo de autenticação por meio de JWT.

Para habilita-lo você precisa adicionar a propriedade **auth** ao arquivo config.yaml
ex:
```
auth:
  jwtSecret: cwsMXDtuP447WZQ63nM4dWZ3RppyMl
  jwtExpire: 3600
  unauthorizedStatusCode: 403
  urlSkip:
    - path_sem_autenticacao:
        method: metodo http (post,get,put,patch ou delete)
```

Descrição das tags:

```yaml
jwtSecret -> Chave de autenticação do jwt (essa chave é importante para validação do token)
jwtExpire -> Tempo de expiração do token
unauthorizedStatusCode -> Status de retorno para acesso negado
urlSkip -> Coloque aqui as urls e métodos http que você não que seja verificada a autenticação do usuário (paths não autenticados)
```

**Exemplo**

No exemplo abaixo, não será verificada a autenticação para o path /users no método post (Cadastro de um novo usuário).

Agora o segundo path **/products/{\*}** você deve ter achado estranho o parâmetro **{\*}**, mas ele é um coringa de acesso, pois, todos os paths configurados no database.json respondem a busca de dados por id, na url ex: **/producs/1** e precisavamos ignorar o id para identificar a url, sendo assim criamos o coringa **{\*}** deixando esse pedaço da url dinâmico permitindo que uma url **/products/1** possa ser acessada sem autenticação.

```json
auth:
  jwtSecret: cwsMXDtuP447WZQ63nM4dWZ3RppyMl
  jwtExpire: 3600
  unauthorizedStatusCode: 403
  urlSkip:
    - /users:
        method: post
    - /products/{*}:
        method: get

```





**Como realizar o login**

Para realizar o login você precisa fazer um post para a url ex: http://localhost:8080/auth com o body:

```json
{
    "email": "rodrigorahman@academiadoflutter.com.br",
    "password": "123"
}
```

O Json Rest Server fará uma busca na sua tabela de users registrada no arquivo database.json e se tudo estiver correto será retornado um json com o token de acesso:

```json
{
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE5NzIzNDMyNTYsImlhdCI6MTY2MTMwMzI1NiwiaXNzIjoianNvbl9yZXN0X3NlcnZlciIsIm5iZiI6MTY2MTMwMzI1Niwic3ViIjoiMyJ9.VVZ_FsW9qXEbR6ktREzVdZ2p9Qw-slXL4EI4CSHHR9o",
    "type": "Bearer"
}
```

Agora para fazer o acesso as suas rotas autenticadas basta enviar o header Authorization com o token concatenado com o type ex:

```dart
Response response = await http.get(
  'http://localhost:8080/products',
  headers: {'authorization': "$type $token"},
);
```
