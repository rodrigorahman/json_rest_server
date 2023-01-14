import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:json_rest_server/src/core/helper/json_helper.dart';
import 'package:json_rest_server/src/core/middlewares/default_content_type.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import '../core/middlewares/auth_middleware.dart';
import '../models/config_model.dart';
import '../repositories/config_repository.dart';
import '../repositories/database_repository.dart';
import 'handler_request.dart';

class JsonRestServer {
  late final ConfigModel _config;
  late final DatabaseRepository _databaseRepository;
  late final JsonHelper _jsonHelper;

  void startServer() {
    _config = ConfigRepository().load();
    _databaseRepository = DatabaseRepository()..load();
    _jsonHelper = JsonHelper().load();
    GetIt.I.registerSingleton(_databaseRepository);
    GetIt.I.registerSingleton(_config);
    GetIt.I.registerSingleton(_jsonHelper);
    _startShelfServer();
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
  }
}
