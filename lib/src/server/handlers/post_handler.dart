import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:json_rest_server/src/core/helper/json_helper.dart';
import 'package:shelf/shelf.dart';

import '../../repositories/database_repository.dart';

class PostHandler {
  final _databaseRepository = GetIt.I.get<DatabaseRepository>();
  final _jsonHelper = GetIt.I.get<JsonHelper>();

  Future<Response> execute(Request request) async {
    final segments = request.url.pathSegments;
    final String table = segments.first;

    if (_databaseRepository.tableExists(table)) {
      var body = await request.readAsString();

      if (body.contains('#userAuthRef')) {
        body = body.replaceAll('#userAuthRef', request.headers['user'] ?? '0');
      }

      _databaseRepository.save(table, jsonDecode(body));
      return Response(
        200,
        headers: _jsonHelper.jsonReturn,
      );
    }

    return Response(404);
  }
}
