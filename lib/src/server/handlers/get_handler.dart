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
    var tableData = _databaseRepository.getAll(table);

    if (queryParameters.containsKey('page')) {
      tableData = _processPagination(tableData, queryParameters);
    }

    return Response(200, body: jsonEncode(tableData), headers: {
      'content-type': 'application/json',
    });
  }

  List<Map<String, dynamic>> _processPagination(
      List<Map<String, dynamic>> tableData,
      Map<String, String> queryParameters) {

    final page = int.parse(queryParameters['page'] ?? '1') - 1;
    final limit = int.parse(queryParameters['limit'] ?? '10');
    final totalList = tableData.length;

    var start = 0;

    if (page == 1) {
      start = limit;
    } else if (page > 1) {
      start = limit * page;
    }

    if (start > totalList) {
      start = totalList;
    }

    var end = start + limit;
    if (end > totalList) {
      end = totalList;
    }
    return tableData.sublist(start, end);
  }
}
