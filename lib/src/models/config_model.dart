import 'dart:convert';

class ConfigModel {
  
  final String name;
  final int port;
  final String? host;
  final String database;

  ConfigModel({
    required this.name,
    required this.port,
    this.host,
    required this.database,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'port': port,
      'host': host,
      'database': database,
    };
  }

  factory ConfigModel.fromMap(Map<String, dynamic> map) {
    return ConfigModel(
      name: map['name'] ?? '',
      port: map['port'] ?? 8080,
      host: map['host'] ?? '',
      database: map['database'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfigModel.fromJson(String source) => ConfigModel.fromMap(json.decode(source));
}
