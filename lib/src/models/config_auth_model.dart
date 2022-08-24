import 'dart:convert';

import 'package:yaml/yaml.dart';

class ConfigAuthModel {
  final String jwtSecret;
  final int jwtExpire;
  final int unauthorizedStatusCode;
  final List<UrlSkip>? urlSkip;

  ConfigAuthModel({
    required this.jwtSecret,
    required this.jwtExpire,
    this.unauthorizedStatusCode = 403,
    this.urlSkip,
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

    return ConfigAuthModel(
      jwtSecret: map['jwtSecret'] ?? '',
      jwtExpire: map['jwtExpire']?.toInt() ?? 0,
      unauthorizedStatusCode: map['unauthorizedStatusCode']?.toInt() ?? 0,
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
}
