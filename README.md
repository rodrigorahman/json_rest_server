

Json Rest Server is a RESTful server based on JSON
<div align="center">


**Languages:**

[![Portuguese](https://img.shields.io/badge/Language-Portuguese-red?style=for-the-badge)](README.pt-br.md)
[![English](https://img.shields.io/badge/Language-English-red?style=for-the-badge)](README.en.md)
</div>

[![Json Rest Server](https://github.com/rodrigorahman/json_rest_server/actions/workflows/dart.yml/badge.svg)](https://github.com/rodrigorahman/json_rest_server/actions/workflows/dart.yml)

# Json Rest Server

Um RESTful server baseado em JSON

Tenha um servidor RESTful 100% funcional com autenticação, paginação e todos os serviços necessários para desenvolvimento de aplicações

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
idType( uuid | int ) -> Agora o json_rest_server suporta que os ids sejam ou integer auto incremental ou uuid
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
GET    /products                                    -> Recuperar todos os produtos
GET    /products?title=jornada                      -> Recuperar todos os produtos com filtro
GET    /products?page=1&limit=10                    -> Recuperar todos os produtos paginado
GET    /products?page=1&limit=10&title=Jornada      -> Recuperar todos os produtos paginado com filtro
GET    /products/1                                  -> Recuperar 1 produto
POST   /products                                    -> Adicionar um produto
PUT    /products/1                                  -> Editar um produto
PATCH  /products/1                                  -> Editar um produto
DELETE /products/1                                  -> Deletar um produto
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
  authFields:
    - matricula:
        type: int
    - celular:
        type: string
```

Descrição das tags:

```yaml
jwtSecret -> Chave de autenticação do jwt (essa chave é importante para validação do token).

jwtExpire -> Tempo de expiração do token em segundos.

enableAdm -> Se habilitado o json_rest_server vai permitir somente requisições de POST, PUT, DELETE para usuários administradores.

urlUserPermission -> Quando habilitado o enableADM você pode permitir que um usuário simples faça as requisições de POST, PUT, DELETE colocando a url aqui.

unauthorizedStatusCode -> Status de retorno para acesso negado.

urlSkip -> Coloque aqui as urls e métodos http que você não que seja verificada a autenticação do usuário (paths não autenticados).

authFields -> Coloque aqui os campos que serão usados na autenticação e seus respectivos tipos para customizar o login.
```

**Exemplo**

No exemplo abaixo, não será verificada a autenticação para o path /users no método post (Cadastro de um novo usuário).

Agora o segundo path **/products/{\*}** você deve ter achado estranho o parâmetro **{\*}**, mas ele é um coringa de acesso, pois, todos os paths configurados no database.json respondem a busca de dados por id, na url ex: **/producs/1** e precisavamos ignorar o id para identificar a url, sendo assim criamos o coringa **{\*}** deixando esse pedaço da url dinâmico permitindo que uma url **/products/1** possa ser acessada sem autenticação.

O parâmetro authFields é **opcional**, e nele deve ser passado os campos que serão usados para fazer a autenticação. É necessário inserir **nome** do campo e o **tipo de dado** como no exemplo abaixo.

Tipos permitidos no authFields -> "**string**", "**int**" ou "**double**"

**Obs:** Caso o parâmetro authFields não seja definido no *config.yaml*, o Json Rest Server manterá a autenticação padrão, que utiliza **"email"** e **"password"**, ambos como string.

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
  authFields:
    - matricula:
        type: int
    - celular:
        type: string
    - nota:
        type: double

```


**Como realizar o login**

Para realizar o login você precisa fazer um post para a url ex: http://localhost:8080/auth com o body:

```json
// Exemplo de request padrão.
{
    "email": "rodrigorahman@academiadoflutter.com.br",
    "password": "123"
}
```

Caso você tenha configurado o authFields para personalizar os campos de login, devem ser enviados os campos da forma como foram definidos no config.yaml.

```json
// Exemplo de request customizada com authFields.
{
    "matricula": 102030,
    "celular": "+5535988881234",
    "nota": 8.5
}
```

O Json Rest Server fará uma busca na sua tabela de users registrada no arquivo database.json e se tudo estiver correto será retornado um json com o token de acesso:

```json
{
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE5NzIzNDMyNTYsImlhdCI6MTY2MTMwMzI1NiwiaXNzIjoianNvbl9yZXN0X3NlcnZlciIsIm5iZiI6MTY2MTMwMzI1Niwic3ViIjoiMyJ9.VVZ_FsW9qXEbR6ktREzVdZ2p9Qw-slXL4EI4CSHHR9o",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NjI0MjI3NTIsImlhdCI6MTY2MTgxNzk1MiwiaXNzIjoiZXlKaGJHY2lPaUpJVXpJMU5pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmxlSEFpT2pFMk5qRTRNVGM1T0RJc0ltbGhkQ0k2TVRZMk1UZ3hOemsxTWl3aWFYTnpJam9pYW5OdmJsOXlaWE4wWDNObGNuWmxjaUlzSW01aVppSTZNVFkyTVRneE56azFNaXdpYzNWaUlqb2lNU0o5LkROV0MwalVQSnc5OExWNGpnREJTTU5CbWFqQnlQYTh2RWNMSXBXSTYybVEiLCJuYmYiOjE2NjE4MTc5ODIsInN1YiI6IlJlZnJlc2hUb2tlbiJ9.2oUEvmJWAiM_jbBGtwsRB-PasgU1R1e6c5aefH98Xrk",
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

**Para um login como administrador você deve enviar no body o parametro admin como true**

```json
{
    "email": "rodrigorahman@academiadoflutter.com.br",
    "password": "123",
    "admin": true
}
```

Dessa forma o Json Rest Server fará a busca na collection `adm_users` podendo assim fazer um login de administrador retornando um json diferente quando recuperado pelo /me, além de permitir o acesso aos métodos POST, PUT, DELETE para todas as collections cadastradas


**Recuperando dados do usuário logado**

Para recuperar os dados do usuário logado você deve acessar o path `/me` enviando o token jwt no header. Automaticamente o Json Rest Server vai recuperar o id do usuário de dentro do token e retornar os dados do usuário sem o atributo password.

Lembrando que fará uma busca na "table" users buscando pelo id.

Ex:

```dart
Response response = await http.get(
  'http://localhost:8080/me',
  headers: {'authorization': "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE5NzIzNDMyNTYsImlhdCI6MTY2MTMwMzI1NiwiaXNzIjoianNvbl9yZXN0X3NlcnZlciIsIm5iZiI6MTY2MTMwMzI1Niwic3ViIjoiMyJ9.VVZ_FsW9qXEbR6ktREzVdZ2p9Qw-slXL4EI4CSHHR9o"},
);
```

**Resposta**

```json
{
    "id": 3,
    "name": "Rodrigo Rahman",
    "email": "rodrigorahman@academiadoflutter.com.br"
}
```

**Refresh token**

O token de acesso tem a duração que você definiu dentro do arquivo config.yaml após esse tempo você não poderá mais acessar as rotas, mas sabemos que em aplicativos existe o processo de acesso permanente e o json_rest_client te ajuda também com isso disponibilizando uma rota para fazer o refresh do token de acesso, não obrigando o usuário a realizar um novo login

Para isso faça o seguinte procedimento.

Quando você realizou o login você recebeu o access_token e o refresh_token, o refresh token tem um tempo de vida de 7 dias, sendo assim para renovar o seu access_token dentro de um prazo de 7 dias envie uma requisição do tipo PUT para o endereço /auth/refresh.

Enviando o seu token de acesso no header e o token de refresh no body.

**Ex:**

```dart
Response response = await http.put(
  'http://localhost:8080/auth/refresh',
  headers: {'authorization': "$type $token"},
  body: jsonEncode({
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NjI0MjI3NTIsImlhdCI6MTY2MTgxNzk1MiwiaXNzIjoiZXlKaGJHY2lPaUpJVXpJMU5pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmxlSEFpT2pFMk5qRTRNVGM1T0RJc0ltbGhkQ0k2TVRZMk1UZ3hOemsxTWl3aWFYTnpJam9pYW5OdmJsOXlaWE4wWDNObGNuWmxjaUlzSW01aVppSTZNVFkyTVRneE56azFNaXdpYzNWaUlqb2lNU0o5LkROV0MwalVQSnc5OExWNGpnREJTTU5CbWFqQnlQYTh2RWNMSXBXSTYybVEiLCJuYmYiOjE2NjE4MTc5ODIsInN1YiI6IlJlZnJlc2hUb2tlbiJ9.2oUEvmJWAiM_jbBGtwsRB-PasgU1R1e6c5aefH98Xrk",
  })
);
```

Você receberá a resposta com um novo token e um novo refresh_token:

```json
{
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE5NzIzNDMyNTYsImlhdCI6MTY2MTMwMzI1NiwiaXNzIjoianNvbl9yZXN0X3NlcnZlciIsIm5iZiI6MTY2MTMwMzI1Niwic3ViIjoiMyJ9.VVZ_FsW9qXEbR6ktREzVdZ2p9Qw-slXL4EI4CSHHR9o",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NjI0MjI3NTIsImlhdCI6MTY2MTgxNzk1MiwiaXNzIjoiZXlKaGJHY2lPaUpJVXpJMU5pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmxlSEFpT2pFMk5qRTRNVGM1T0RJc0ltbGhkQ0k2TVRZMk1UZ3hOemsxTWl3aWFYTnpJam9pYW5OdmJsOXlaWE4wWDNObGNuWmxjaUlzSW01aVppSTZNVFkyTVRneE56azFNaXdpYzNWaUlqb2lNU0o5LkROV0MwalVQSnc5OExWNGpnREJTTU5CbWFqQnlQYTh2RWNMSXBXSTYybVEiLCJuYmYiOjE2NjE4MTc5ODIsInN1YiI6IlJlZnJlc2hUb2tlbiJ9.2oUEvmJWAiM_jbBGtwsRB-PasgU1R1e6c5aefH98Xrk",
    "type": "Bearer"
}
```
Basta agora enviar novamente a requisição passando o novo token.

## ATENÇÃO: Lembre que agora você recebeu um novo token de acesso e o antigo DEVE ser descartado!


## Criando referencia ao usuário logado no seu json
Você pode querer adicionar uma coluna com o dado do usuário que está logado.

Para fazer essa associação, basta enviar no value do field o valor #userAuthRef ex:

```json
{
    "title": "Academia do flutter",
    "user_id": "#userAuthRef"
}
```

O Json Rest Server vai substituir o valor de #userAuthRef pelo id do usuário logado, lembrando que essa tag só poderá ser usada para serviços que utilizem autenticação pois o valor será substituido pelo id do usuário enviado no tokenJWT.


## Buscando dados com filtro por usuário logado.

Para fazer a busca por um campo com o ID do usuário logado, você precisa enviar no filtro a tag #userAuthRef, o Json Rest Server vai substituir o valor pelo id do usuário logado ex:

`http://localhost:8080/products?user_id=#userAuthRef`

O JRS vai substituir a tag #userAuthRef pelo o id do usuário logado e realizar o filtro no campo user_id



## Sistema de broadcast event
Foi desenvolvido um sistema de broadcast para enviar dados para outras aplicações com uma configuração inicial simples no seu config.yaml
Inicialmente o sistema está compatível com o envio para ***socket e slack***

```yaml

enableSocket: true
#Indica se você quer que inicie um servidor de socket junto com o servidor rest (true/false)
socketPort: 8081
#Indica a porta de acesso do socket padrão (Websocket não utiliza essa porta):  8081
broadcastProvider: socket
#Indica pra qual tipo de broadcast ele quer enviar por padrão : ex  socket,slack  ou só socket ou só slack
slack:
  slackUrl:
  #Indica a url do webhook do slack
  slackChannel:
  #Indica o canal do slack para ser enviado sempre começando com #
  ```

  ## Para emitir os eventos, os providers precisam estar configurados , e no caso do socket somente se existir clientes conectados o envio é efetuado, assim garantindo que não seja disparado nenhum serviço sem necessidade

  Voce pode incluir no header uma chave chamada  **socket-channel**, e assim que o verbo (POST,PUT,DELETE,PATCH) for emitido, o socket irá emitir a resposta desse verbo no channel escolhido, caso não seja escolhido nada o nome do channel sera **VERBO**

## Broadcast event com Websocket

O Json Rest server suporta também a comunicação socket para web utilizando websocket, quando você habilita o parâmetro `enableSocket: true` no config você automaticamente está habilitando também o websocket podendo receber socket pelo IO ou Websocket.

No websocket a porta de conexão sempre será a mesma do servidor.

Veja um exemplo de conexão utilizando o Flutter Web:

```dart
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final WebSocketChannel channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080'),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebSocket Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('WebSocket Demo'),
        ),
        body: Center(
          child: StreamBuilder(
            stream: channel.stream,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: switch (snapshot) {
                  AsyncSnapshot(hasData: true, :final data) => Text('$data'),
                  _ => const Text(''),
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
```

O exemplo acima mostra uma conexão websocket padrão onde qualquer alteração no backend será enviada e lida pelo websocket.

## Filtro de notificação websocket

Em algumas situações não queremos escutar as alterações em todas as tabelas do sistema, sendo assim no websocket é possível adicionar um filtro por tabela que você gostaria de escutar.

Ex:

Vamos supor que você gostaria de receber no socket somente as alterações nas tabelas (user e products), sendo assim basta no momento da conexão com o websocket você enviar o parâmetro `tables` com as tabelas que você gostaria de escutar.

Ex:

```dart
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final WebSocketChannel channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080?tables=users,products'),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebSocket Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('WebSocket Demo'),
        ),
        body: Center(
          child: StreamBuilder(
            stream: channel.stream,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: switch (snapshot) {
                  AsyncSnapshot(hasData: true, :final data) => Text('$data'),
                  _ => const Text(''),
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
```

**Pronto agora o seu websocket receberá alterações somente das tabelas users e products**

> **Atenção**: Caso você conect no socket com filtro você SÓ recebera alterações das tabelas informadas


## Suporte a conteúdos estáticos (Imagens)

Json Rest Server agora da suporte a url de conteúdo (Imagens) estáticas.

Para habilitar o suporte a esse recurso em projetos existentes siga os passos abaixo:

1 - Na raiz do seu projeto, crie uma pasta storage
2 - Coloque as imagens dentro dessa pasta e agora você terá acesso a url `http://localhost:8080/storage`

## Upload de arquivos

Para realizar upload de arquivos você deve fazer um post para a url `http://localhost:8080/uploads` e enviar o arquivo por formData.

**Obs**: é muito importante que você envie o nome do arquivo dentro do multpartFile

**Exemplo:**

```dart
 final formData = FormData.fromMap({
    'file': await MultipartFile.fromFile(
      './storage/nome_imagem.png',
      filename: 'nome_imagem.png',
    ),
  });

  final response = await Dio().post(
    'http://localhost:8080/uploads',
    data: formData,
    options: Options(
      headers: {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG0iOnRydWUsImV4cCI6MTY4MDQ0Mjk1OCwiaWF0IjoxNjgwNDM5MzU4LCJpc3MiOiJqc29uX3Jlc3Rfc2VydmVyIiwibmJmIjoxNjgwNDM5MzU4LCJzdWIiOiIwIn0.TWhCCYnJABi1RYzKIKFVspRHZi2-5iqgxALTYTzSeQ0',
      },
    ),
  );
  ```