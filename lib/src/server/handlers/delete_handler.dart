import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';

import '../../repositories/database_repository.dart';

class DeleteHandler {
  final _databaseRepository = GetIt.I.get<DatabaseRepository>();
  Future<Map<String, dynamic>?> execute(Request request) async {
    final segments = request.url.pathSegments;
    final String table = segments.first;

    if (segments.length < 2) {
      return null;
    }

    final String id = segments[1];

    if (_databaseRepository.tableExists(table)) {
      final deletedData = _databaseRepository.getById(table, int.parse(id));
      _databaseRepository.delete(table, int.parse(id));
      if (deletedData.isNotEmpty) {
        deletedData['id'] = int.parse(id);
      }
      return deletedData;
    }
    return null;
  }
}
