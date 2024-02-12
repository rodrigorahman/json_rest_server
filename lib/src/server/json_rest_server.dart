import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:json_rest_server/src/core/broadcast/broadcast_controller.dart';
import 'package:json_rest_server/src/core/helper/cors_helper.dart';
import 'package:json_rest_server/src/core/middlewares/default_content_type.dart';
import 'package:json_rest_server/src/server/core/env.dart';
import 'package:json_rest_server/src/server/socket/websocket_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import '../core/middlewares/auth_middleware.dart';
import '../models/config_model.dart';
import '../repositories/config_repository.dart';
import '../repositories/database_repository.dart';
import 'handler_request.dart';
import 'socket/socket_handler.dart';

class JsonRestServer {
  late final ConfigModel _config;
  late final DatabaseRepository _databaseRepository;
  late final CorsHelper _corsHelper;
  late final SocketHandler _socketHandler;
  late final BroadCastController _broadcast;
  final Env env;

  JsonRestServer(this.env);

  Future<void> startServer() async {
    final getIt = GetIt.I;
    getIt.registerSingleton(env);
    _config = ConfigRepository().load(env.debugPath);
    _databaseRepository = DatabaseRepository(_config)..load(env.debugPath);
    _corsHelper = CorsHelper().load();
    _broadcast = BroadCastController();
    getIt.registerSingleton(_databaseRepository);
    getIt.registerSingleton(_config);
    getIt.registerSingleton(_corsHelper);
    getIt.registerSingleton(_broadcast);
    await _startShelfServer();
  }

  Future<void> _startShelfServer() async {
    // Use any available host or container IP (usually `0.0.0.0`).
    final ip = _config.host ?? InternetAddress.anyIPv4;
    // Configure a pipeline that logs requests.
    final handler = Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(DefaultContentType('application/json').handler)
        .addMiddleware(AuthMiddleware().handler)
        .addHandler(HandlerRequest().execute);

    // For running in containers, we respect the PORT environment variable.

    final ConfigModel(:port, :name, :enableSocket, :socketPort) = _config;

    var webSocketHandler = WebSocketHandler();
    GetIt.I.registerSingleton(webSocketHandler);

    var cascadeServer = Cascade().add(handler);

    if (enableSocket) {
      cascadeServer = cascadeServer.add((Request request) => webSocketHandler.load(request));
      print('Websocket loaded in port 8080');
    }

    final serverHandler = cascadeServer.handler;

    await serve(serverHandler, ip, port);
    if (ip == '0.0.0.0') {
      final networks = await NetworkInterface.list(type: InternetAddressType.IPv4);
      final networksMap = {
        for (final NetworkInterface(
              :name,
              addresses: List(
                last: InternetAddress(:address),
              )
            ) in networks)
          name.toLowerCase(): address
      };

      final ethernet = networksMap['ethernet'];
      final wifi = networksMap['wi-fi'];

      print('$name Server started, responding on:');
      print('http://localhost:$port/');
      if (ethernet != null) print('http://$ethernet:$port/');
      if (wifi != null) print('http://$wifi:$port/');
    } else {
      print('$name Server started on http://$ip:$port');
    }

    if (enableSocket && socketPort != null) {
      if (socketPort == port) {
        print('Socket port $socketPort cannot be the same of the server port $port');

        exit(0);
      }
      _socketHandler = await SocketHandler().load(socketPort: socketPort, socketIp: '$ip');
      print('Socket is started on port $socketPort');
      GetIt.I.registerSingleton(_socketHandler);
    }
  }
}
