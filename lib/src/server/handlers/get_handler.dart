import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:json_rest_server/src/core/helper/cors_helper.dart';
import 'package:json_rest_server/src/models/config_model.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_static/shelf_static.dart';

import '../../repositories/database_repository.dart';

class GetHandler {
  final _databaseRepository = GetIt.I.get<DatabaseRepository>();
  final _jsonHelper = GetIt.I.get<CorsHelper>();
  final _config = GetIt.I.get<ConfigModel>();
  Future<Response> execute(Request request) async {
    final Uri(pathSegments: segments) = request.url;

    switch (segments) {
      case List(isEmpty: true):
        return Response(404);
      case List(isEmpty: false, first: 'flutter_service_worker.js'):
        return Response.ok(jsonEncode({}));
      case List(isEmpty: false, first: 'me'):
        return _processMe(request);
      case List(isEmpty: false, first: 'storage'):
        return _storageProcess(request);
      case List(isEmpty: false, first: final table, length: final totalSegments)
          when _databaseRepository.tableExists(table):
        return switch (totalSegments) {
          > 1 => _processById(table, segments[1]),
          _ =>
            _processGetAll(table, request.url.queryParameters, request.headers)
        };
      case _:
        return Response(404);
    }
  }

  Future<Response> _storageProcess(Request request) async {
    Response response = await createStaticHandler('./').call(request);
    final headers = {
      'keepContentType': 'false',
      ..._jsonHelper.jsonReturn,
    };
    headers.remove('content-type');
    return response.change(headers: headers);
  }

  Future<Response> _processById(String table, String id) async {
    switch (id) {
      case String(isEmpty: true):
        return Response.badRequest(
            body: jsonEncode({'error': 'param id required'}));
      case _:
        final result =
            _databaseRepository.getById(table, int.tryParse(id) ?? id);

        return Response(
          200,
          body: jsonEncode(result),
          headers: _jsonHelper.jsonReturn,
        );
    }
  }

  Future<Response> _processMe(Request request) async {
    String? id;
    bool adm = request.headers['adm'] == 'true';

    if (_config.auth == null) {
      return Response(404,
          body: jsonEncode({
            'message':
                'authentication not configured, please check documentation'
          }));
    } else {
      id = request.headers['user'];
    }

    if (id == null || id.isEmpty) {
      return Response.badRequest(
          body: jsonEncode({'error': 'param id required'}));
    }

    final result = {
      ..._databaseRepository.getById(
        adm ? 'adm_users' : 'users',
        id,
      )
    };
    result.remove('password');

    return Response(200,
        body: jsonEncode(result), headers: _jsonHelper.jsonReturn);
  }

  Future<Response> _processGetAll(
      String table,
      final Map<String, String> queryParameters,
      Map<String, String> headers) async {
    var tableData = _databaseRepository.getAll(table);

    switch (queryParameters) {
      case {'page': _}:
        tableData = _processPagination(tableData, queryParameters, headers);
      case Map(isNotEmpty: true):
        tableData = _filterData(tableData, queryParameters, headers);
    }
    return Response(
      200,
      body: jsonEncode(tableData),
      headers: _jsonHelper.jsonReturn,
    );
  }

  List<Map<String, dynamic>> _processPagination(
      List<Map<String, dynamic>> tableData,
      Map<String, String> queryParameters,
      Map<String, String> headers) {
    final params = {...queryParameters};
    params.remove('page');
    params.remove('limit');

    if (params.isNotEmpty) {
      tableData = _filterData(tableData, params, headers);
    }

    final pageParam = int.tryParse(queryParameters['page'] ?? '1') ?? 1;

    final page = pageParam - 1;
    final limit = int.tryParse(queryParameters['limit'] ?? '10') ?? 10;
    final totalList = tableData.length;

    var start = switch (page) { == 1 => limit, > 1 => limit * page, _ => 0 };

    if (start > totalList) {
      start = totalList;
    }

    var end = start + limit;

    if (end > totalList) {
      end = totalList;
    }
    return tableData.sublist(start, end);
  }

  List<Map<String, dynamic>> _filterData(List<Map<String, dynamic>> tableData,
      Map<String, String> queryParameters, Map<String, String> headers) {
    final data = [...tableData];

    queryParameters.forEach((key, value) {
      data.retainWhere((element) {
        var valueFilter = value;
        if (valueFilter == '#userAuthRef') {
          valueFilter = headers['user'] ?? '0';
        }
        return element[key]
            .toString()
            .toLowerCase()
            .contains(valueFilter.toLowerCase());
      });
    });

    return data;
  }
}
