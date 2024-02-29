import 'dart:convert';
import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:json_rest_server/src/core/helper/cors_helper.dart';
import 'package:shelf/shelf.dart';

import '../../models/config_model.dart';
import '../../repositories/database_repository.dart';
import '../exceptions/config_not_found_exception.dart';
import '../helper/jwt_helper.dart';
import 'middlewares.dart';

class AuthMiddleware extends Middlewares {
  final _config = GetIt.I.get<ConfigModel>();
  final _database = GetIt.I.get<DatabaseRepository>();
  final jsonHelper = GetIt.I.get<CorsHelper>();

  @override
  Future<Response> execute(Request request) async {
    if (request.url.path == '' || request.method == 'OPTIONS') {
      return innerHandler(request);
    }
    var segments = request.url.pathSegments;
    if (segments.last == 'auth') {
      return _login(request);
    } else if (request.method == 'PUT' && segments.length > 1 && segments[segments.length - 2] == 'auth' && segments.last == 'refresh') {
      return _refreshToken(request);
    } else if (_config.auth != null && segments.first != 'storage') {
      return _checkLogin(request);
    } else {
      return innerHandler(request);
    }
  }

  Future<Response> _login(Request request) async {
    try {
      final authConfig = _config.auth;
      final body = await request.readAsString();
      final bodyData = jsonDecode(body);

      final adminLogin = bodyData['admin'] ?? false;
      final users = _database.getAll(adminLogin ? 'adm_users' : 'users');

      if (users.isEmpty) {
        return Response(
          500,
          body: jsonEncode({'erro': 'user table not exists'}),
          headers: jsonHelper.jsonReturn,
        );
      }

      var user = {};

      if (authConfig?.authFields.isEmpty ?? true) {
        user = users.firstWhere(
          (user) {
            return (user['email'] == bodyData['email'] && user['password'] == bodyData['password']);
          },
          orElse: () => {},
        );
      } else {
        int numberOfFields = authConfig!.authFields.length;
        int validatedFields = 0;

        for (var u in users) {
          for (var field in authConfig.authFields) {
            if (!(bodyData as Map).containsKey(field.name)) {
              return Response(
                500,
                body: jsonEncode(
                    {'error': 'field ${field.name} not found in validation. Please check if you put this validation in config.yaml  then remove it or send the correct fields to authenticate'}),
                headers: jsonHelper.jsonReturn,
              );
            }

            dynamic dataAsType;

            switch (field.type.toLowerCase()) {
              case 'string':
                dataAsType = bodyData[field.name] as String;
                break;

              case 'int':
                dataAsType = bodyData[field.name] as int;
                break;

              case 'double':
                dataAsType = bodyData[field.name] as double;
                break;
            }

            if (u[field.name] == dataAsType) {
              validatedFields++;
            } else {
              validatedFields = 0;
              break;
            }
          }

          if (validatedFields == numberOfFields) {
            user = u;
            break;
          }
        }
      }

      if (user.isEmpty) {
        return Response.forbidden(
          jsonEncode({'error': 'Forbidden Access'}),
          headers: jsonHelper.jsonReturn,
        );
      }

      final token = JwtHelper.generateJWT(user['id'], adminLogin);
      final refreshToken = JwtHelper.refreshToken(token);

      return Response.ok(
        jsonEncode({
          'access_token': token,
          'refresh_token': refreshToken,
          'type': 'Bearer',
        }),
        headers: jsonHelper.jsonReturn,
      );
    } on ConfigNotFoundException catch (e, s) {
      log('Auth config not found check config.yaml', error: e, stackTrace: s);
      return Response(
        500,
        body: jsonEncode({'erro': 'Auth config not found check config.yaml'}),
        headers: jsonHelper.jsonReturn,
      );
    }
  }

  Future<Response> _checkLogin(Request request) async {
    try {
      final authConfig = _config.auth!;
      final skipUrl = authConfig.urlSkip;
      final pathUrl = '/${request.url.path}';
      final method = request.method;
      final methodsCheck = ['post', 'put', 'delete'];

      if (skipUrl != null &&
          skipUrl.any((element) {
            if (element.path.contains('{*}')) {
              final segments = Uri(path: element.path).pathSegments;
              final pathSegments = request.url.pathSegments;
              var valid = true;

              if (segments.length != pathSegments.length) {
                valid = false;
              } else {
                for (int i = 0; i < pathSegments.length; i++) {
                  if (segments[i] == '{*}' && int.tryParse(pathSegments[i]) != null) {
                    continue;
                  }

                  if (segments[i] == pathSegments[i]) {
                    continue;
                  }
                  valid = false;
                  break;
                }
              }

              return valid;
            } else {
              return (element.path == pathUrl && element.method.toLowerCase() == method.toLowerCase());
            }
          })) {
        return innerHandler(request);
      }

      final authHeader = request.headers['Authorization'];

      if (authHeader == null || authHeader.isEmpty) {
        throw JwtException.invalidToken;
      }

      final authHeaderContent = authHeader.split(' ');

      if (authHeaderContent[0] != 'Bearer') {
        throw JwtException.invalidToken;
      }

      final authorizationToken = authHeaderContent[1];
      final claims = JwtHelper.getClaims(authorizationToken);

      claims.validate();

      final claimsMap = claims.toJson();

      final userId = claimsMap['sub'];
      final adm = claims['adm'];

      if (userId == null) {
        throw JwtException.invalidToken;
      }

      if (methodsCheck.contains(method.toLowerCase())) {
        if (authConfig.enableAdm) {
          if (!adm && !authConfig.urlUserPermission.contains(pathUrl)) {
            throw JwtException.invalidToken;
          }
        }
      }

      final securityHeaders = {
        'user': userId,
        'adm': '$adm',
        'access_token': authorizationToken,
      };

      return innerHandler(request.change(headers: securityHeaders));
    } on JwtException catch (e, s) {
      log('Erro ao validar token JWT', error: e, stackTrace: s);
      return Response(
        _config.auth?.unauthorizedStatusCode ?? 403,
        headers: jsonHelper.jsonReturn,
      );
    } catch (e, s) {
      log('Internal Server Error', error: e, stackTrace: s);
      return Response(
        _config.auth?.unauthorizedStatusCode ?? 403,
        headers: jsonHelper.jsonReturn,
      );
    }
  }

  Future<Response> _refreshToken(Request request) async {
    final bodyText = await request.readAsString();
    final body = jsonDecode(bodyText);

    final authHeader = request.headers['Authorization'] ?? '';
    final authHeaderContent = authHeader.split(' ');

    if (authHeaderContent[0] != 'Bearer') {
      throw JwtException.invalidToken;
    }
    _validRefreshToken(authHeaderContent[1], body['refresh_token'] ?? '');
    final claims = JwtHelper.getClaims(authHeaderContent[1]).toJson();

    final id = claims['sub'];
    final adm = claims['adm'];

    final token = JwtHelper.generateJWT(int.parse(id), adm);
    final refreshToken = JwtHelper.refreshToken(token);

    return Response.ok(
      jsonEncode({
        'access_token': token,
        'refresh_token': refreshToken,
        'type': 'Bearer',
      }),
      headers: jsonHelper.jsonReturn,
    );
  }

  void _validRefreshToken(String accessToken, String refreshToken) {
    // final refreshTokenArr = refreshToken.split(' ');

    // if (refreshTokenArr.length != 2 || refreshTokenArr.first != 'Bearer') {
    //   throw JwtException('Refresh token invalido');
    // }

    final refreshTokenClaim = JwtHelper.getClaims(refreshToken);
    refreshTokenClaim.validate(issuer: accessToken);
  }
}
