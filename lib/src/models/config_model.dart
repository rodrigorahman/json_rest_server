import 'dart:convert';

import 'package:json_rest_server/src/models/id_type_enum.dart';
import 'package:json_rest_server/src/models/slack_model.dart';
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
  final List<String>? broadcastProvider;
  final SlackModel? slack;
  final IdTypeEnum idType;

  ConfigModel(
      {required this.name,
      required this.port,
      this.host,
      required this.database,
      this.auth,
      this.enableSocket = false,
      this.socketPort,
      this.broadcastProvider = const [],
      this.slack,
      this.idType = IdTypeEnum.int});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'port': port,
      'host': host,
      'database': database,
      'auth': auth?.toMap(),
      'enableSocket': enableSocket,
      'socketPort': socketPort,
      'broadcastProvider': broadcastProvider,
      'slack': slack?.toMap()
    };
  }

  factory ConfigModel.fromMap(Map<String, dynamic> map) {
    final YamlMap? auth = map['auth'];
    // print(json.encode(map['slack']));
    return ConfigModel(
      name: map['name'] ?? '',
      port: map['port'] ?? 8080,
      host: map['host'] ?? '',
      database: map['database'] ?? '',
      auth: auth != null ? ConfigAuthModel.fromMap(auth.value.cast()) : null,
      enableSocket: map['enableSocket'] ?? false,
      socketPort: map['socketPort'] ?? 0,
      broadcastProvider: map['broadcastProvider'] == null
          ? null
          : (map['broadcastProvider'] as String)
              .split(',')
              .map<String>((e) => e)
              .toSet()
              .toList(),
      slack: map['slack'] == null
          ? null
          : SlackModel.fromJson(
              json.encode(
                map['slack'],
              ),
            ),
      idType: IdTypeEnum.parse(map['idType']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfigModel.fromJson(String source) =>
      ConfigModel.fromMap(json.decode(source));
}
