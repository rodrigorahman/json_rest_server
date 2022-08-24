import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';

import '../../core/exceptions/table_not_exists_exception.dart';
import '../../repositories/database_repository.dart';

class PatchHandler {
  final _databaseRepository = GetIt.I.get<DatabaseRepository>();

  Future<Response> execute(Request request) async {
    final segments = request.url.pathSegments;
    final String table = segments.first;

    if (segments.length < 2) {
      return Response(404);
    }

    final String id = segments[1];

    if (_databaseRepository.tableExists(table)) {
      final body = await request.readAsString();
      final dataUpdate = jsonDecode(body);
      dataUpdate['id'] = int.parse(id);
      _databaseRepository.save(table, dataUpdate);
      return Response(200, headers: {
        'content-type': 'application/json',
      });
    }

    throw TableNotExistsException();
  }
}
