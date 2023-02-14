import 'dart:convert';

import 'package:yaml/yaml.dart';

import 'config_auth_model.dart';

class ConfigModel {
  final String name;
  final int port;
  final String? host;
  final String database;
  final ConfigAuthModel? auth;
  final bool enableSocket;
  final int? socketPort;

  ConfigModel({
    required this.name,
    required this.port,
    this.host,
    required this.database,
    this.auth,
    this.enableSocket = false,
    this.socketPort,
  });

  Map<String, dynamic> toMap() {
    return {'name': name, 'port': port, 'host': host, 'database': database, 'auth': auth?.toMap(), 'enableSocket': enableSocket, 'socketPort': socketPort};
  }

  factory ConfigModel.fromMap(Map<String, dynamic> map) {
    final YamlMap? auth = map['auth'];

    return ConfigModel(
      name: map['name'] ?? '',
      port: map['port'] ?? 8080,
      host: map['host'] ?? '',
      database: map['database'] ?? '',
      auth: auth != null ? ConfigAuthModel.fromMap(auth.value.cast()) : null,
      enableSocket: map['enableSocket'] ?? false,
      socketPort: map['socketPort'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfigModel.fromJson(String source) => ConfigModel.fromMap(json.decode(source));
}
