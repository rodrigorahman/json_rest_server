import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:json_rest_server/src/core/broadcast/broadcast_controller.dart';
import 'package:json_rest_server/src/core/exceptions/conflict_id_exception.dart';
import 'package:json_rest_server/src/core/exceptions/resource_notfound_exception.dart';
import 'package:json_rest_server/src/core/helper/cors_helper.dart';
import 'package:json_rest_server/src/models/broadcast_model.dart';
import 'package:json_rest_server/src/models/config_model.dart';
import 'package:json_rest_server/src/server/handlers/option_handler.dart';
import 'package:json_rest_server/src/server/handlers/upload_handler.dart';
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

    final Map<String, dynamic>? mapResponse;

    try {
      if (request.headers.keys.contains('mock-delay')) {
        int delay = int.tryParse(request.headers['mock-delay'].toString()) ?? 0;
        await Future.delayed(Duration(
            seconds: delay)); // will wait here until the timeout finish
      }
      switch (method) {
        case 'GET':
          return GetHandler().execute(request);
        case 'POST':
          if (request.url.path == 'uploads') {
            mapResponse = await UploadHandler().execute(request);
            return Response.ok(
              jsonEncode(mapResponse),
              headers: jsonHelper.jsonReturn,
            );
          } else {
            mapResponse = await PostHandler().execute(request);
          }
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
            'error': 'Unsupported request: $method.',
          });
          return Response(
            HttpStatus.methodNotAllowed,
            body: body,
            headers: jsonHelper.jsonReturn,
          );
      }

      if (mapResponse == null) {
        return Response(
          404,
          headers: jsonHelper.jsonReturn,
        );
      } else {
        final [table, ...] = request.url.pathSegments;
        final channel = switch (request.headers) {
          {'socket-channel': final socketChannel} => socketChannel,
          _ => method
        };

        broadcast.execute(
          providers: config.broadcastProvider,
          broadcast: BroadcastModel.fromRequest(
            channel: channel,
            table: table,
            data: mapResponse,
          ),
        );

        return Response(
          body: json.encode(mapResponse),
          200,
          headers: jsonHelper.jsonReturn,
        );
      }
    } on ConflictIdException catch (e, s) {
      log('Erro interno', error: e, stackTrace: s);

      return Response(
        415,
        body: jsonEncode(
          {'erro': e.message},
        ),
        headers: jsonHelper.jsonReturn,
      );
    } on ResourceNotfoundException catch (e, s) {
      log('Resource not found', error: e, stackTrace: s);
      return Response.notFound(
        jsonEncode(
          {'erro': 'resource not found'},
        ),
        headers: jsonHelper.jsonReturn,
      );
    } catch (e, s) {
      log('Erro interno', error: e, stackTrace: s);
      return Response.internalServerError(
        body: jsonEncode(
          {'erro': e.toString()},
        ),
        headers: jsonHelper.jsonReturn,
      );
    }
  }
}
