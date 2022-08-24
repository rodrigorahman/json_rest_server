import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';

import '../../core/exceptions/table_not_exists_exception.dart';
import '../../repositories/database_repository.dart';

class GetHandler {
  final _databaseRepository = GetIt.I.get<DatabaseRepository>();
  Future<Response> execute(Request request) async {
    final segments = request.url.pathSegments;
    final String table = segments.first;

    if (_databaseRepository.tableExists(table)) {
      if (segments.length > 1) {
        return _processById(table, segments[1]);
      } else {
        return _processGetAll(table, request.url.queryParameters);
      }
    }
    throw TableNotExistsException();
  }

  Future<Response> _processById(String table, String id) async {
    final result = _databaseRepository.getById(table, int.parse(id));

    return Response(200, body: jsonEncode(result), headers: {
      'content-type': 'application/json',
    });
  }

  Future<Response> _processGetAll(
      String table, Map<String, String> queryParameters) async {
    return Response(200,
        body: jsonEncode(_databaseRepository.getAll(table)),
        headers: {
          'content-type': 'application/json',
        });
  }
}
