// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:json_rest_server/src/server/socket/socket_handler.dart';

class SocketEmiter {
  final SocketHandler? socket = GetIt.I.isRegistered<SocketHandler>() ? GetIt.I.get<SocketHandler>() : null;

  void sendToSocket({required String method, required String table, required dynamic data}) async {
    if (socket != null) {
      await socket!.sendMessage(EmiterModel(method: method, table: table, data: data).toJson());
    }
  }
}

class EmiterModel {
  final String method;
  final String table;
  final dynamic data;
  EmiterModel({
    required this.method,
    required this.table,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'method': method,
      'table': table,
      'data': data,
    };
  }

  factory EmiterModel.fromMap(Map<String, dynamic> map) {
    return EmiterModel(
      method: map['method'] as String,
      table: map['table'] as String,
      data: map['data'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EmiterModel.fromJson(String source) => EmiterModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
