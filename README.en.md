Json Rest Server is a RESTful server based on JSON
<div align="center">

**Languages:**

[![Portuguese](https://img.shields.io/badge/Language-Portuguese-red?style=for-the-badge)](README.pt-br.md)
[![English](https://img.shields.io/badge/Language-English-red?style=for-the-badge)](README.en.md)
</div>

[![Json Rest Server](https://github.com/rodrigorahman/json_rest_server/actions/workflows/dart.yml/badge.svg)](https://github.com/rodrigorahman/json_rest_server/actions/workflows/dart.yml)

# Json Rest Server 
A RESTful server based on JSON

With this package you can have a fully functional RESTful server with auth, pagination and all the necessaries services do build an application

## Installation
1. Install dart Dart (https://dart.dev/get-dart), just IF you don't have the flutter in your computer

2. Active the package  Json Rest Server using  dart pub
```
dart pub global activate json_rest_server
```


## Settings

The config.yaml file contains the server settings

Below is a description of the parameters:

```
name -> Name of your server
port -> access port
host -> Access IP, if you want it to respond by ip and localhost, put 0.0.0.0
database -> filename of your database
idType( uuid | int ) -> Now json_rest_server supports ids to be either integer auto incremental or uuid
```

## Commands

***IMPORTANT**: 
The default executable in your project is json_rest_server, but you can also use ***jsonRestServer*** or just ***jrs*** to make it short  ;-)

**UPGRADE**:

Upgrade the Json Rest Server version:

```
json_rest_server upgrade
```

**Creating the project**
The commands below will create all the necessaries things do run your server

In an empty folder you can execute this command
```e
json_rest_server create
```

You can also create a folder using the command below
```
json_rest_server create ./nome_pasta
```

**Starting the Server**

The command below will run a server based in the configurations that is in the config.yaml file 

Then you can jump in the folder that you create and execute this command
```
json_rest_server run
```

## Routes

When we start the Json Rest Server, it will create routes based on RESTful concept in database.json file

Each key will be created in this file and also your routes, ex:

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

***Routes created***:

```
GET    /products                                    -> Get all the products
GET    /products?title=jornada                      -> Get all the products with filter
GET    /products?page=1&limit=10                    -> Get all products with pagination
GET    /products?page=1&limit=10&title=jornada      -> Get all products with pagination with filter
GET    /products/1                                  -> Get 1 product based on ID
POST   /products                                    -> Create a product
PUT    /products/1                                  -> Edit a product based on ID
PATCH  /products/1                                  -> Edit a product based on ID
DELETE /products/1                                  -> Delete a product based on ID
```

***IMPORTANT: The post, put and patch MUST have a json body ***

In the example folder there is a postman file with all the examples above

## Authentication

Json Rest Server already have all the auth process using JWT.

To enable it, you need to add the propertie **auth** in your config.yaml file
ex:
```
auth:
  jwtSecret: cwsMXDtuP447WZQ63nM4dWZ3RppyMl
  jwtExpire: 3600
  unauthorizedStatusCode: 403
  urlSkip:
    - path_without_authentication:
        method: http method (post,get,put,patch ou delete)
  authFields:
    - matricula:
        type: int
    - celular:
        type: string
```

Tags description:

```yaml
jwtSecret -> JWT's authentication key (this key is very important to validade the token)
jwtExpire -> You token expiration in seconds
enableAdm -> Se habilitado o json_rest_server vai permitir somente requisições de POST, PUT, DELETE para usuários administradores
urlUserPermission -> Quando habilitado o enableADM você pode permitir que um usuário simples faça as requisições de POST, PUT, DELETE colocando a url aqui.
unauthorizedStatusCode ->  The status to use in case of denied access
urlSkip -> Urls that you don't want to be verified with JWT
authFields(optional) -> Please list the fields that will be used for authentication and their respective types to customize the login.
```

**Example**


In the example below the server will not verify the authentication to  /user in post method (To create a new user )

Now in the second path **/products/{\*}** , this strange command **{\*}**, is a wilcard, because all the paths in the  database.json that use an ID in the url, like **/producs/1**, we need to ignore the url parameter to find the url. With this wilcard we allow to make some dynamc urls to be accessed without authentication

The authFields parameter is **optional**, and it should contain the fields that will be used for authentication. It is necessary to include the **name** of the field and the **data type** as in the example below.

Allowed types in authFields -> "**string**", "**int**", or "**double**"

**Note:** If the authFields parameter is not defined in the *config.yaml*, the Json Rest Server will maintain the default authentication, which uses **"email"** and **"password"**, both as string.

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
    - registration:
        type: int
    - mobile:
        type: string
    - grade:
        type: double

```

***How to login***

To login and authenticate you need to make a post request in the url ex: http://localhost:8080/auth  with the body:

```json
{
    "email": "rodrigorahman@academiadoflutter.com.br",
    "password": "123"
}
```

If you have configured the authFields to customize the login fields, the fields should be sent as they were defined in the config.yaml.

```json
// Example of a custom request with authFields.
{
    "registration": 102030,
    "mobile": "+5535988881234",
    "grade": 8.5
}
```

The Json Rest Server will find in your user's table the email that you sent in database.json, and if it's there you will recieve a json with an access token

```json
{
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE5NzIzNDMyNTYsImlhdCI6MTY2MTMwMzI1NiwiaXNzIjoianNvbl9yZXN0X3NlcnZlciIsIm5iZiI6MTY2MTMwMzI1Niwic3ViIjoiMyJ9.VVZ_FsW9qXEbR6ktREzVdZ2p9Qw-slXL4EI4CSHHR9o",
    "type": "Bearer"
}
```

Now to use the other routes, you need to send in your header the Authorization with your access_token like in the example below:

```dart
Response response = await http.get(
  'http://localhost:8080/products',
  headers: {'authorization': "$type $token"},
);
```


**To login as an administrator, you must send the parameter "admin" as true in the body**

```json
{
    "email": "rodrigorahman@academiadoflutter.com.br",
    "password": "123",
    "admin": true
}
```

This way, the Json Rest Server will search the `adm_users` collection, enabling the login as an administrator and returning a different JSON when retrieved by `/me`, in addition to allowing access to the POST, PUT, and DELETE methods for all registered collections.



**Get logged in user data**

To get the data of the logged in user you must access the `/me` path by sending the jwt token in the header. Json Rest Server will automatically retrieve the user id from within the token and return the user data without the password attribute.

Remembering that you will search the "table" users looking for the id.

Ex:

```dart
Response response = await http.get(
  'http://localhost:8080/me',
  headers: {'authorization': "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE5NzIzNDMyNTYsImlhdCI6MTY2MTMwMzI1NiwiaXNzIjoianNvbl9yZXN0X3NlcnZlciIsIm5iZiI6MTY2MTMwMzI1Niwic3ViIjoiMyJ9.VVZ_FsW9qXEbR6ktREzVdZ2p9Qw-slXL4EI4CSHHR9o"},
);
```

**Response**

```json
{
    "id": 3,
    "name": "Rodrigo Rahman",
    "email": "rodrigorahman@academiadoflutter.com.br"
}
```



**Refresh token**

The access token has the duration that you defined inside the config.yaml file, after that time you will no longer be able to access the routes, but we know that in applications there is a permanent access process and json_rest_client also helps you with this by providing a route to refresh the access token, not forcing the user to perform a new login

To do this, do the following procedure.

When you logged in you received the access_token and refresh_token, the refresh token has a lifetime of 7 days, so to renew your access_token within 7 days send a PUT request to the address /auth /refresh.

Sending your access token in the header and the refresh token in the body.

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

You will get the response with a new token and a new refresh_token:

```json
{
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE5NzIzNDMyNTYsImlhdCI6MTY2MTMwMzI1NiwiaXNzIjoianNvbl9yZXN0X3NlcnZlciIsIm5iZiI6MTY2MTMwMzI1Niwic3ViIjoiMyJ9.VVZ_FsW9qXEbR6ktREzVdZ2p9Qw-slXL4EI4CSHHR9o",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NjI0MjI3NTIsImlhdCI6MTY2MTgxNzk1MiwiaXNzIjoiZXlKaGJHY2lPaUpJVXpJMU5pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmxlSEFpT2pFMk5qRTRNVGM1T0RJc0ltbGhkQ0k2TVRZMk1UZ3hOemsxTWl3aWFYTnpJam9pYW5OdmJsOXlaWE4wWDNObGNuWmxjaUlzSW01aVppSTZNVFkyTVRneE56azFNaXdpYzNWaUlqb2lNU0o5LkROV0MwalVQSnc5OExWNGpnREJTTU5CbWFqQnlQYTh2RWNMSXBXSTYybVEiLCJuYmYiOjE2NjE4MTc5ODIsInN1YiI6IlJlZnJlc2hUb2tlbiJ9.2oUEvmJWAiM_jbBGtwsRB-PasgU1R1e6c5aefH98Xrk",
    "type": "Bearer"
}
```
Now just send the request again, passing the new token.

## ATTENTION: Remember that you have now received a new access token and the old one MUST be discarded!

## Broadcast event system
A broadcast system was developed to send data to other applications with a simple initial configuration in your config.yaml
Initially, the system is compatible with sending to ***socket and slack***

```yaml

enableSocket: true 
#Indicates whether you want to start a socket server along with the rest server (true/false)
socketPort: 8081
#Indicates the default socket access port (Websocket does not use this port): 8081
broadcastProvider: socket
#Indicates which type of broadcast it wants to send by default: eg socket, slack or just socket or just slack
slack: 
  slackUrl:
  #Indicates the url of the slack webhook
  slackChannel:
  #Indicates the slack channel to send always starting with #
```
   
   ## To send the events, the providers need to be configured, and in the case of the socket, only if there are connected clients are they sent, thus guaranteeing that no unnecessary service is triggered.

   You can include in the header a key called **socket-channel**, and as soon as the verb (POST,PUT,DELETE,PATCH) is issued, the socket will emit the response of that verb on the chosen channel, if nothing is chosen the channel name will be **VERB**


## Broadcast Event with WebSocket

The Json Rest server also supports socket communication for the web using WebSocket. When you enable the `enableSocket: true` parameter in the configuration, you automatically enable WebSocket, allowing you to receive sockets via IO or WebSocket.

In WebSocket, the connection port will always be the same as that of the server.

Here is an example of a connection using Flutter Web:

```dart
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

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
The example above shows a standard WebSocket connection where any changes in the backend will be sent and read through WebSocket.

## WebSocket Notification Filter

In some situations, we may not want to listen to changes in all tables of the system. Therefore, in WebSocket, it is possible to add a filter for the table you would like to listen to.

**For example:**

Let's suppose you only want to receive changes in the tables (user and products) on the socket. In that case, during the WebSocket connection, you can send the tables parameter with the tables you would like to listen to.

For example:

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
Now your WebSocket will only receive changes from the tables users and products.

>**Note:** If you connect to the socket with a filter, you will ONLY receive changes from the specified tables.



## Support for static content (images).

Json Rest Server now supports static content (images) URL.

To enable support for this feature in existing projects, follow the steps below:

1 - In the root of your project, create a folder named storage.
2 - Place the images inside that folder, and now you will have access to the URL `http://localhost:8080/storage`.

## File upload

To perform file upload, you must make a POST request to the URL `http://localhost:8080/uploads` and send the file using formData.


**Note:** It is very important that you send the file name within the multipartFile.


**Example:**

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