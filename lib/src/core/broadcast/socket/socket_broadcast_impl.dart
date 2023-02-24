// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:json_rest_server/src/models/broadcast_model.dart';
import 'package:json_rest_server/src/server/socket/socket_handler.dart';

import '../broadcast_base.dart';

class SocketBroadCastImpl implements BroadcastBase {
  final SocketHandler? _socket;
  SocketBroadCastImpl({
    SocketHandler? socket,
  }) : _socket = socket;
  @override
  Future<bool> execute({required BroadcastModel broadcast}) async {
    if (_socket == null) {
      return false;
    }
    _socket!.sendMessage(broadcast.toJson());
    log('Send to socket', time: DateTime.now());

    return true;
  }
}
