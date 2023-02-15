import 'package:get_it/get_it.dart';
import 'package:json_rest_server/src/core/helper/cors_helper.dart';
import 'package:json_rest_server/src/server/socket/socket_emiter.dart';
import 'package:shelf/shelf.dart';

import '../../repositories/database_repository.dart';

class DeleteHandler extends SocketEmiter {
  final _databaseRepository = GetIt.I.get<DatabaseRepository>();
  final _jsonHelper = GetIt.I.get<CorsHelper>();
  Future<Response> execute(Request request) async {
    final segments = request.url.pathSegments;
    final String table = segments.first;

    if (segments.length < 2) {
      return Response(404);
    }

    final String id = segments[1];

    if (_databaseRepository.tableExists(table)) {
      _databaseRepository.delete(table, int.parse(id));

      sendToSocket(method: 'DELETE', table: table, data: int.parse(id));
      return Response(200, headers: _jsonHelper.jsonReturn);
    }

    return Response(404);
  }
}
