import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:json_rest_server/src/core/broadcast/broadcast_controller.dart';
import 'package:json_rest_server/src/core/helper/cors_helper.dart';
import 'package:json_rest_server/src/core/middlewares/default_content_type.dart';
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

  Future<void> startServer() async {
    _config = ConfigRepository().load();
    _databaseRepository = DatabaseRepository(_config)..load();
    _corsHelper = CorsHelper().load();
    _broadcast = BroadCastController();
    GetIt.I.registerSingleton(_databaseRepository);
    GetIt.I.registerSingleton(_config);
    GetIt.I.registerSingleton(_corsHelper);
    GetIt.I.registerSingleton(_broadcast);
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
    final port = _config.port;
    await serve(handler, ip, port);
    if (ip == '0.0.0.0') {
      final networks = await NetworkInterface.list();
      final networksMap = {
        for (var element in networks)
          element.name.toLowerCase(): element.addresses.first.address
      };
      final ethernet = networksMap['ethernet'];

      final wifi = networksMap['wi-fi'];
      print('${_config.name} Server started, responding on:');
      print('http://localhost:$port/');
      if (ethernet != null) print('http://$ethernet:$port/');
      if (wifi != null) print('http://$wifi:$port/');
    } else {
      print('${_config.name} Server started on http://$ip:$port');
    }

    if (_config.enableSocket && _config.socketPort != null) {
      if (_config.socketPort == _config.port) {
        print(
            'Socket port ${_config.socketPort} cannot be the same of the server port $port');

        exit(0);
      }
      _socketHandler = await SocketHandler().load(
          socketPort: _config.socketPort ?? 8081, socketIp: ip.toString());
      print('Socket is started on port ${_config.socketPort}');
      GetIt.I.registerSingleton(_socketHandler);
    }
  }
}
