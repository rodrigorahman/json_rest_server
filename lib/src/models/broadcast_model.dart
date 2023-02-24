import 'dart:convert';

import 'package:json_rest_server/src/core/enum/broadcast_type.dart';

class BroadcastModel {
  final String method;
  final String table;
  final Map<String, dynamic> payload;
  final BroadCastType? broadCastType;
  DateTime? sentAt;
  BroadcastModel(
      {required this.method,
      required this.table,
      required this.payload,
      required this.broadCastType,
      this.sentAt});

  BroadcastModel copyWith({
    String? method,
    String? table,
    Map<String, dynamic>? payload,
    BroadCastType? broadCastType,
  }) {
    return BroadcastModel(
      method: method ?? this.method,
      table: table ?? this.table,
      payload: payload ?? this.payload,
      broadCastType: broadCastType ?? this.broadCastType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'method': method,
      'table': table,
      'payload': payload,
      'broadCastType': broadCastType?.name,
      'sentAt': DateTime.now().toIso8601String(),
    };
  }

  factory BroadcastModel.fromMap(Map<String, dynamic> map) {
    return BroadcastModel(
      method: map['method'] as String,
      table: map['table'] as String,
      payload:
          Map<String, dynamic>.from(map['payload'] as Map<String, dynamic>),
      broadCastType: (map['broadCastType'] == null)
          ? null
          : BroadCastType.fromString(
              map['broadCastType'],
            ),
    );
    // );
  }

  String toJson() => json.encode(toMap());

  factory BroadcastModel.fromJson(String source) =>
      BroadcastModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BroadcastModel(method: $method, table: $table, payload: $payload, broadCastType: $broadCastType)';
  }

  factory BroadcastModel.fromRequest(
      {required String method,
      required String table,
      required Map<String, dynamic> data}) {
    return BroadcastModel(
      method: method,
      table: table,
      payload: data,
      broadCastType: null,
    );
  }
}
