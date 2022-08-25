Json Rest Server is a RESTful server based on JSON
<div align="center">

**Languages:**

[![Portuguese](https://img.shields.io/badge/Language-Portuguese-red?style=for-the-badge)](README.pt-br.md)
[![English](https://img.shields.io/badge/Language-English-red?style=for-the-badge)](README.en.md)
</div>

# Json Rest Server 
A RESTful server based on JSON

With this package you can have a fully functional restfull server with auth, pagination and all the necessaries services do build an application

## Installation
1. Install dart Dart (https://dart.dev/get-dart), just IF you don't have the flutter in your computer

2. Active the package  Json Rest Server using  dart pub
```
dart pub global activate json_rest_server
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
```

Tags description:

```yaml
jwtSecret -> JWT's authentication key (this key is very important to validade the token)
jwtExpire -> You token expiration in seconds
unauthorizedStatusCode ->  The status to use in case of denied access
urlSkip -> Urls that you don't want to be verified with JWT
```

**Example**


In the example below the server will not verify the authentication to  /user in post method (To create a new user )

Now in the second path **/products/{\*}** , this strange command **{\*}**, is a wilcard, because all the paths in the  database.json that use an ID in the url, like **/producs/1**, we need to ignore the url parameter to find the url. With this wilcard we allow to make some dynamc urls to be accessed without authentication

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

***How to login***

To login and authenticate you need to make a post request in the url ex: http://localhost:8080/auth  with the body:

```json
{
    "email": "rodrigorahman@academiadoflutter.com.br",
    "password": "123"
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