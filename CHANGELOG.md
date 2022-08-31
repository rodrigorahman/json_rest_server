## 1.0.0

- Initial version.

## 1.0.2

- Beta version.

## 1.0.3

- Bug fix create project

## 1.0.4

- Bug fix logs

## 1.0.5

- adding shortcuts to run (json_rest_client, jsonRestClient or jsr)

## 1.0.6

- Fix Readme and examples

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

## 1.0.8

- Add Readme en

## 1.0.11

- Add Example and fix pub points 

## 1.0.12

- dart format all files

## 1.0.13

- adding filter support in getAll searches

```
GET    /products?title=jornada                      -> Get all the products with filter
GET    /products?page=1&limit=10&title=jornada      -> Get all products with pagination with filter
```

## 1.0.14

- Running dart format in files for updating pub points.

## 1.0.15

- Fix template and Readme.

## 1.0.16

- Fix port that is presented at server start.


## 1.1.0

- Token access time fix
- Add refresh token support for login system

## 1.1.1
- fix format code

## 1.1.2
- fix bug: post with id null

## 1.1.3
- fix bug: Error for save a first data on table

## 1.2.0
- new feature, now we can get the data of the user logged in by the token