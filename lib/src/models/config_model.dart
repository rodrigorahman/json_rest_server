import 'dart:convert';

import 'package:yaml/yaml.dart';

import 'config_auth_model.dart';

class ConfigModel {
  
  final String name;
  final int port;
  final String? host;
  final String database;
  final ConfigAuthModel? auth;

  ConfigModel({
    required this.name,
    required this.port,
    this.host,
    required this.database,
    this.auth,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'port': port,
      'host': host,
      'database': database,
      'auth': auth?.toMap(),
    };
  }

  factory ConfigModel.fromMap(Map<String, dynamic> map) {

    final YamlMap? auth = map['auth'];

    return ConfigModel(
      name: map['name'] ?? '',
      port: map['port'] ?? 8080,
      host: map['host'] ?? '',
      database: map['database'] ?? '',
      auth: auth != null ? ConfigAuthModel.fromMap(auth.value.cast()) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfigModel.fromJson(String source) => ConfigModel.fromMap(json.decode(source));
}
