import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';

import '../../repositories/database_repository.dart';

class DeleteHandler {
  final _databaseRepository = GetIt.I.get<DatabaseRepository>();

  Future<Response> execute(Request request) async {
    final segments = request.url.pathSegments;
    final String table = segments.first;

    if (segments.length < 2) {
      return Response(404);
    }

    final String id = segments[1];

    if (_databaseRepository.tableExists(table)) {
      _databaseRepository.delete(table, int.parse(id));
      return Response(200, headers: {
        'content-type': 'application/json',
      });
    }

    return Response(404);
  }
}
