import 'dart:convert';


class ConfigAuthModel {
  final String jwtSecret;
  final int jwtExpire;
  final int unauthorizedStatusCode;
  final List<String>? urlSkip; 
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
    return ConfigAuthModel(
      jwtSecret: map['jwtSecret'] ?? '',
      jwtExpire: map['jwtExpire']?.toInt() ?? 0,
      unauthorizedStatusCode: map['unauthorizedStatusCode']?.toInt() ?? 0,
      urlSkip: List<String>.from(map['urlSkip'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfigAuthModel.fromJson(String source) => ConfigAuthModel.fromMap(json.decode(source));
}
