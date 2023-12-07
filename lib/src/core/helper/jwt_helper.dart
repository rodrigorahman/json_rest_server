import 'package:get_it/get_it.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import '../../models/config_model.dart';
import '../exceptions/config_not_found_exception.dart';

class JwtHelper {
  JwtHelper._();

  static String generateJWT(dynamic userId, bool adm) {
    final config = GetIt.I.get<ConfigModel>();
    final jwtExpire = config.auth?.jwtExpire;
    final jwtSecret = config.auth?.jwtSecret;

    if (jwtExpire == null || jwtSecret == null) {
      throw ConfigNotFoundException();
    }

    final claimSet = JwtClaim(
      issuer: 'json_rest_server',
      otherClaims: {'adm': adm},
      subject: userId.toString(),
      expiry: DateTime.now().add(Duration(seconds: jwtExpire)),
      notBefore: DateTime.now(),
      issuedAt: DateTime.now(),
    );

    return issueJwtHS256(claimSet, jwtSecret);
  }

  static String refreshToken(String accessToken) {
    final config = GetIt.I.get<ConfigModel>();
    final jwtExpire = config.auth?.jwtExpire;
    final jwtSecret = config.auth?.jwtSecret;

    if (jwtExpire == null || jwtSecret == null) {
      throw ConfigNotFoundException();
    }

    final expiry = 7;
    final notBefore = jwtExpire;

    final claimSet = JwtClaim(
      issuer: accessToken,
      subject: 'RefreshToken',
      expiry: DateTime.now().add(Duration(days: expiry)),
      notBefore: DateTime.now().add(Duration(seconds: notBefore)),
      issuedAt: DateTime.now(),
      otherClaims: <String, dynamic>{},
    );

    return issueJwtHS256(claimSet, jwtSecret);
  }

  static JwtClaim getClaims(String token) {
    final config = GetIt.I.get<ConfigModel>();
    final jwtExpire = config.auth?.jwtExpire;
    final jwtSecret = config.auth?.jwtSecret;

    if (jwtExpire == null || jwtSecret == null) {
      throw ConfigNotFoundException();
    }

    return verifyJwtHS256Signature(token, jwtSecret);
  }
}
