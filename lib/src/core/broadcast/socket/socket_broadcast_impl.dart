// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:json_rest_server/src/models/broadcast_model.dart';
import 'package:json_rest_server/src/server/socket/socket_handler.dart';
import 'package:json_rest_server/src/server/socket/websocket_handler.dart';

import '../broadcast_base.dart';

class SocketBroadCastImpl implements BroadcastBase {
  final SocketHandler? socket;
  final WebSocketHandler? websocket;
  SocketBroadCastImpl({
    this.socket,
    this.websocket,
  });

  @override
  Future<bool> execute({required BroadcastModel broadcast}) async {
    final sent = socket?.sendMessage(broadcast.toJson()) ?? false;
    final websent = websocket?.sendMessage(broadcast.toJson()) ?? false;

    if (sent) {
      log('Send to socket', time: DateTime.now());
    }

    if (websent) {
      log('Send to websocket', time: DateTime.now());
    }

    return true;
  }
}
