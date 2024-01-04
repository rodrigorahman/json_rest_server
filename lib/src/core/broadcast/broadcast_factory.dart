import 'package:get_it/get_it.dart';
import 'package:json_rest_server/src/core/broadcast/broadcast_base.dart';
import 'package:json_rest_server/src/core/broadcast/slack/slack_broadcast_impl.dart';
import 'package:json_rest_server/src/core/broadcast/socket/socket_broadcast_impl.dart';
import 'package:json_rest_server/src/core/enum/broadcast_type.dart';
import 'package:json_rest_server/src/models/broadcast_model.dart';
import 'package:json_rest_server/src/models/config_model.dart';
import 'package:json_rest_server/src/server/socket/socket_handler.dart';
import 'package:json_rest_server/src/server/socket/websocket_handler.dart';

class BroadcastFactory {
  static BroadcastBase? create({required BroadcastModel broadcast}) {
    switch (broadcast.broadCastType) {
      case BroadCastType.socket:
        return SocketBroadCastImpl(
          socket: GetIt.I.isRegistered<SocketHandler>()
              ? GetIt.I.get<SocketHandler>()
              : null,
          websocket: GetIt.I.isRegistered<WebSocketHandler>()
              ? GetIt.I.get<WebSocketHandler>()
              : null,
        );

      case BroadCastType.slack:
        return SlackBroadCastImpl(config: GetIt.I.get<ConfigModel>());

      default:
        return null;
    }
  }
}
