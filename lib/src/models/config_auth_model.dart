import 'dart:convert';

import 'package:yaml/yaml.dart';

class ConfigAuthModel {
  final String jwtSecret;
  final int jwtExpire;
  final int unauthorizedStatusCode;
  final bool enableAdm;
  final List<String> urlUserPermission;
  final List<UrlSkip>? urlSkip;

  ConfigAuthModel({
    required this.jwtSecret,
    required this.jwtExpire,
    this.unauthorizedStatusCode = 403,
    this.urlSkip,
    this.urlUserPermission = const <String>[],
    this.enableAdm = false
  });

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
    
    return ConfigAuthModel(
      jwtSecret: map['jwtSecret'] ?? '',
      jwtExpire: map['jwtExpire']?.toInt() ?? 0,
      unauthorizedStatusCode: map['unauthorizedStatusCode']?.toInt() ?? 403,
      enableAdm: map['enableAdm'] ?? false,
      urlUserPermission: urlUserPermission?.toList().cast() ?? <String>[],
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

  factory ConfigAuthModel.fromJson(String source) =>
      ConfigAuthModel.fromMap(json.decode(source));
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
