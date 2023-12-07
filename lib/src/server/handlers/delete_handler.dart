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
      final deletedData =
          _databaseRepository.getById(table, int.tryParse(id) ?? id);
      _databaseRepository.delete(table, int.tryParse(id) ?? id);
      if (deletedData.isNotEmpty) {
        deletedData['id'] = int.tryParse(id) ?? id;
      }
      return deletedData;
    }
    return null;
  }
}
