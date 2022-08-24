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