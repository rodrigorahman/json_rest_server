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
    final segments = request.url.pathSegments;

    if (segments.isEmpty) {
      return Response(404);
    }
    final String table = segments.first;

    switch (table) {
      case 'flutter_service_worker.js':
        return Response.ok(jsonEncode({}));
      case 'me':
        return _processMe(request);
      case 'storage':
        Response response = await createStaticHandler('./').call(request);

        return response.change(
            headers: {'keepContentType': 'false', ..._jsonHelper.jsonReturn});
      default:
        if (_databaseRepository.tableExists(table)) {
          if (segments.length > 1) {
            return _processById(table, segments[1]);
          } else {
            return _processGetAll(
                table, request.url.queryParameters, request.headers);
          }
        }
    }
    return Response(404);
  }

  Future<Response> _processById(String table, String id) async {
    if (id.isEmpty) {
      return Response.badRequest(
          body: jsonEncode({'error': 'param id required'}));
    }

    final result = _databaseRepository.getById(table, int.parse(id));

    return Response(
      200,
      body: jsonEncode(result),
      headers: _jsonHelper.jsonReturn,
    );
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
      ..._databaseRepository.getById(adm ? 'adm_users' : 'users', int.parse(id))
    };
    result.remove('password');

    return Response(200,
        body: jsonEncode(result), headers: _jsonHelper.jsonReturn);
  }

  Future<Response> _processGetAll(String table,
      Map<String, String> queryParameters, Map<String, String> headers) async {
    var tableData = _databaseRepository.getAll(table);
    var params = {...queryParameters};

    if (params.containsKey('page')) {
      tableData = _processPagination(tableData, queryParameters, headers);
    } else {
      if (params.isNotEmpty) {
        tableData = _filterData(tableData, queryParameters, headers);
      }
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
