import 'dart:convert';

import 'package:json_rest_server/src/core/enum/broadcast_type.dart';

class BroadcastModel {
  final String channel;
  final String table;
  final Map<String, dynamic> payload;
  final BroadCastType? broadCastType;
  DateTime? sentAt;
  BroadcastModel(
      {required this.channel,
      required this.table,
      required this.payload,
      required this.broadCastType,
      this.sentAt});

  BroadcastModel copyWith({
    String? channel,
    String? table,
    Map<String, dynamic>? payload,
    BroadCastType? broadCastType,
  }) {
    return BroadcastModel(
      channel: channel ?? this.channel,
      table: table ?? this.table,
      payload: payload ?? this.payload,
      broadCastType: broadCastType ?? this.broadCastType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'channel': channel,
      'table': table,
      'payload': payload,
      'broadCastType': broadCastType?.name,
      'sentAt': DateTime.now().toIso8601String(),
    };
  }

  factory BroadcastModel.fromMap(Map<String, dynamic> map) {
    return BroadcastModel(
      channel: map['channel'] as String,
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
    return 'BroadcastModel(channel: $channel, table: $table, payload: $payload, broadCastType: $broadCastType)';
  }

  factory BroadcastModel.fromRequest(
      {required String channel,
      required String table,
      required Map<String, dynamic> data}) {
    return BroadcastModel(
      channel: channel,
      table: table,
      payload: data,
      broadCastType: null,
    );
  }
}
