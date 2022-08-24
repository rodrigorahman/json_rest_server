import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:shelf/shelf.dart';

import 'handlers/delete_handler.dart';
import 'handlers/get_handler.dart';
import 'handlers/patch_handler.dart';
import 'handlers/post_handler.dart';
import 'handlers/put_handler.dart';

class HandlerRequest {
  Future<Response> execute(Request request) async {
    final method = request.method;
    try {
      switch (method) {
        case 'GET':
          return GetHandler().execute(request);
        case 'POST':
          return PostHandler().execute(request);
        case 'PUT':
          return PutHandler().execute(request);
        case 'PATCH':
          return PatchHandler().execute(request);
        case 'DELETE':
          return DeleteHandler().execute(request);
        default:
          final body = jsonEncode({
            'error': 'Unsupported request: ${request.method}.',
          });
          return Response(HttpStatus.methodNotAllowed, body: body);
      }
    } catch (e, s) {
      log('Erro interno', error: e, stackTrace: s);
      return Response.internalServerError(
          body: jsonEncode({'erro': e.toString()}));
    }
  }
}
