## 2.0.3
  fix: Bug fix pattern matching in post handler

## 2.0.2
  fix: Bug fix pattern matching in put handler
  feat: new debug in externals project with  DART DEFINE (define=debugPath)

## 2.0.1
- FIX websocket documentation

## 2.0.0
- **BREAK CHANGE**: added support for dart 3
- Added Websocket for broadcast

## 1.7.0
- Feat: Added support for UUID instead of int for primary key.

## 1.6.0
- Feat: Add socket-channel in header to execute websocket in a custom channel 

## 1.5.10
- Bug: verb put not working when key not exists

## 1.5.8
- Bug: content-type wrong when get storage 

## 1.5.8
- Bug: /me was removing the password field causing login to stop working

## 1.5.7
- Fix: Add cors on upload image storage

## 1.5.6
- Fix: Add cors on get image storage

## 1.5.5
- Fix: Add cors on errors 401 inside middleware

## 1.5.4
- Fix: Add cors on errors

## 1.5.3
- Fix: Add cors on login 


## 1.5.2
- Fix: Options with authentication 

## 1.5.1
- Fix: Readme format 

## 1.5.0
- Added support for static files
- Added support for administrator login for use in the Backoffice
- Added support for file upload


## 1.4.1
- Bugfix (issue https://github.com/rodrigorahman/json_rest_server/issues/7) json_rest_server status version error

## 1.4.0
- Support for WebSocket and adding login to another collection to support a possible administrator."

## 1.3.2
- patch method correction and added options method with cors support

## 1.3.0
- new feature, now we can associate user_id of user logged in any json field

## 1.2.4
- fix Json Rest Server - Did not authenticate any path  

## 1.2.3
- fix Json Rest Server - Bad state: No element #4  

## 1.2.2
- License Review

## 1.2.1
- Changelog fix

## 1.2.0
- new feature, now we can get the data of the user logged in by the token

## 1.1.3
- fix bug: Error for save a first data on table


## 1.1.2
- fix bug: post with id null


## 1.1.1
- fix format code


## 1.1.0

- Token access time fix
- Add refresh token support for login system

## 1.0.16

- Fix port that is presented at server start.

## 1.0.15

- Fix template and Readme.

## 1.0.14

- Running dart format in files for updating pub points.

## 1.0.13

- adding filter support in getAll searches

```
GET    /products?title=jornada                      -> Get all the products with filter
GET    /products?page=1&limit=10&title=jornada      -> Get all products with pagination with filter
```

## 1.0.12

- dart format all files

## 1.0.11

- Add Example and fix pub points 

## 1.0.8

- Add Readme en

## 1.0.7

- Fix logs
- Adding the possibility to bypass authentication by paths and methods
```yaml
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

## 1.0.6

- Fix Readme and examples

## 1.0.5

- adding shortcuts to run (json_rest_client, jsonRestClient or jsr)

## 1.0.4

- Bug fix logs

## 1.0.3

- Bug fix create project
## 1.0.2

- Beta version.

## 1.0.0

- Initial version.

