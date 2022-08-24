import 'dart:convert';
import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:shelf/shelf.dart';

import '../../models/config_model.dart';
import '../../repositories/database_repository.dart';
import '../exceptions/config_not_found_exception.dart';
import '../helper/jwt_helper.dart';
import 'middlewares.dart';

class AuthMiddleware extends Middlewares {
  final _config = GetIt.I.get<ConfigModel>();
  final _database = GetIt.I.get<DatabaseRepository>();

  @override
  Future<Response> execute(Request request) async {
    var segments = request.url.pathSegments;
    if (segments.last == 'auth') {
      return _login(request);
    } else if (_config.auth != null) {
      return _checkLogin(request);
    } else {
      return innerHandler(request);
    }
  }

  Future<Response> _login(Request request) async {
    try {
      final body = await request.readAsString();
      final bodyData = jsonDecode(body);

      final users = _database.getAll('users');

      if (users.isEmpty) {
        return Response(500,
            body: jsonEncode({'erro': 'user table not exists'}));
      }

      var user = users.firstWhere(
        (user) {
          return (user['email'] == bodyData['email'] &&
              user['password'] == bodyData['password']);
        },
        orElse: () => {},
      );

      if (user.isEmpty) {
        return Response.forbidden(jsonEncode({'error': 'Forbidden Access'}));
      }

      final token = JwtHelper.generateJWT(user['id']);

      return Response.ok(
        jsonEncode({'access_token': token, 'type': 'Bearer'}),
      );
    } on ConfigNotFoundException catch (e, s) {
      log('Auth config not found check config.yaml', error: e, stackTrace: s);
      return Response(500,
          body:
              jsonEncode({'erro': 'Auth config not found check config.yaml'}));
    }
  }

  Future<Response> _checkLogin(Request request) async {
    try {
      final segments = request.url.pathSegments;
      final skipUrl = _config.auth!.urlSkip;
      if (skipUrl != null && skipUrl.contains(segments[0])) {
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

      if (userId == null) {
        throw JwtException.invalidToken;
      }

      final securityHeaders = {
        'user': userId,
        'access_token': authorizationToken,
      };

      return innerHandler(request.change(headers: securityHeaders));
    } on JwtException catch (e, s) {
      log('Erro ao validar token JWT', error: e, stackTrace: s);
      return Response(_config.auth?.unauthorizedStatusCode ?? 403);
    } catch (e, s) {
      log('Internal Server Error', error: e, stackTrace: s);
      return Response(_config.auth?.unauthorizedStatusCode ?? 403);
    }
  }
}
