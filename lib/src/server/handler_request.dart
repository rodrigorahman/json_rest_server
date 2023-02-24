import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:json_rest_server/src/core/broadcast/broadcast_controller.dart';
import 'package:json_rest_server/src/core/helper/cors_helper.dart';
import 'package:json_rest_server/src/models/broadcast_model.dart';
import 'package:json_rest_server/src/models/config_model.dart';
import 'package:json_rest_server/src/server/handlers/option_handler.dart';
import 'package:shelf/shelf.dart';

import 'handlers/delete_handler.dart';
import 'handlers/get_handler.dart';
import 'handlers/patch_handler.dart';
import 'handlers/post_handler.dart';
import 'handlers/put_handler.dart';

class HandlerRequest {
  Future<Response> execute(Request request) async {
    final method = request.method;
    final config = GetIt.I.get<ConfigModel>();
    final broadcast = GetIt.I.get<BroadCastController>();

    final jsonHelper = GetIt.I.get<CorsHelper>();

    late final Map<String, dynamic>? mapResponse;

    try {
      switch (method) {
        case 'GET':
          return GetHandler().execute(request);
        case 'POST':
          mapResponse = await PostHandler().execute(request);
          break;
        case 'PUT':
          mapResponse = await PutHandler().execute(request);
          break;
        case 'PATCH':
          mapResponse = await PatchHandler().execute(request);
          break;
        case 'DELETE':
          mapResponse = await DeleteHandler().execute(request);
          break;

        case 'OPTIONS':
          return await OptionHandler().execute(request);
        default:
          final body = jsonEncode({
            'error': 'Unsupported request: ${request.method}.',
          });
          return Response(HttpStatus.methodNotAllowed, body: body);
      }

      if (mapResponse == null) {
        return Response(404);
      } else {
        broadcast.execute(
          providers: config.broadcastProvider,
          broadcast: BroadcastModel.fromResponse(
            request: request,
            data: mapResponse,
          ),
        );
        return Response(
          body: json.encode(mapResponse),
          200,
          headers: jsonHelper.jsonReturn,
        );
      }
    } catch (e, s) {
      log('Erro interno', error: e, stackTrace: s);
      return Response.internalServerError(body: jsonEncode({'erro': e.toString()}));
    }
  }
}
