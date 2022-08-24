import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:json_rest_server/src/core/exceptions/table_not_exists_exception.dart';
import 'package:shelf/shelf.dart';

import '../../repositories/database_repository.dart';

class PostHandler {
  final _databaseRepository = GetIt.I.get<DatabaseRepository>();

  Future<Response> execute(Request request) async {
    final segments = request.url.pathSegments;
    final String table = segments.first;

    if (_databaseRepository.tableExists(table)) {
      final body = await request.readAsString();
      _databaseRepository.save(table, jsonDecode(body));
      return Response(200, headers: {
        'content-type': 'application/json',
      });
    }

    throw TableNotExistsException();
  }
}
