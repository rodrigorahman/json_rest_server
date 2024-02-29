import 'dart:convert';
import 'package:yaml/yaml.dart';

class ConfigAuthModel {
  final String jwtSecret;
  final int jwtExpire;
  final int unauthorizedStatusCode;
  final bool enableAdm;
  final List<String> urlUserPermission;
  final List<AuthField> authFields;
  final List<UrlSkip>? urlSkip;

  ConfigAuthModel(
      {required this.jwtSecret,
      required this.jwtExpire,
      this.unauthorizedStatusCode = 403,
      this.urlSkip,
      this.urlUserPermission = const <String>[],
      this.authFields = const <AuthField>[],
      this.enableAdm = false});

  Map<String, dynamic> toMap() {
    return {
      'jwtSecret': jwtSecret,
      'jwtExpire': jwtExpire,
      'urlSkip': urlSkip,
    };
  }

  factory ConfigAuthModel.fromMap(Map<String, dynamic> map) {
    YamlList? urlSkip = map['urlSkip'];
    YamlList? urlUserPermission = map['urlUserPermission'];
    YamlList? authFields = map['authFields'];

    return ConfigAuthModel(
      jwtSecret: map['jwtSecret'] ?? '',
      jwtExpire: map['jwtExpire']?.toInt() ?? 0,
      unauthorizedStatusCode: map['unauthorizedStatusCode']?.toInt() ?? 403,
      enableAdm: map['enableAdm'] ?? false,
      urlUserPermission: urlUserPermission?.toList().cast() ?? <String>[],
      authFields: authFields?.map<AuthField>((element) {
            var key = element.keys.first;
            return AuthField(
              name: key,
              type: element.value[key]['type'],
            );
          }).toList() ??
          [],
      urlSkip: urlSkip?.map<UrlSkip>(
            (element) {
              var key = element.keys.first;
              return UrlSkip(
                path: key,
                method: element.value[key]['method'],
              );
            },
          ).toList() ??
          [],
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfigAuthModel.fromJson(String source) => ConfigAuthModel.fromMap(json.decode(source));
}

class UrlSkip {
  final String path;
  final String method;

  UrlSkip({
    required this.path,
    required this.method,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'path': path,
      'method': method,
    };
  }

  factory UrlSkip.fromMap(Map<String, dynamic> map) {
    return UrlSkip(
      path: (map['path'] ?? '') as String,
      method: (map['method'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UrlSkip.fromJson(String source) => UrlSkip.fromMap(json.decode(source) as Map<String, dynamic>);
}

class AuthField {
  final String name;
  final String type;

  AuthField({
    required this.name,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'type': type,
    };
  }

  factory AuthField.fromMap(Map<String, dynamic> map) {
    return AuthField(
      name: (map['name'] ?? '') as String,
      type: (map['type'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthField.fromJson(String source) => AuthField.fromMap(json.decode(source) as Map<String, dynamic>);
}
