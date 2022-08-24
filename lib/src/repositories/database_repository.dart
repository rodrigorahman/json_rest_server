import 'dart:convert';
import 'dart:io';

class DatabaseRepository {
  late Map<String, dynamic> _database;

  void load() {
    final databaseFile = File('database.json');

    if (!databaseFile.existsSync()) {
      databaseFile.createSync();
      databaseFile.writeAsStringSync('{}');
    }

    _database = jsonDecode(databaseFile.readAsStringSync());
  }

  bool tableExists(String table) => _database.containsKey(table);

  List<Map<String, dynamic>> getAll(String table) =>
      _database[table]?.cast<Map<String, dynamic>>() ??
      <Map<String, dynamic>>[];

  Map<String, dynamic> getById(String table, int id) => getAll(table)
      .firstWhere((element) => element['id'] == id, orElse: () => {});

  void save(String table, Map<String, dynamic> data) {
    final id = data['id'];
    var lineData = <String, dynamic>{};
    if (id != null) {
      lineData = getById(table, id);
    }

    if (lineData.isNotEmpty) {
      lineData.updateAll((key, value) => data[key]);
    } else {
      final tableData = getAll(table);
      final lastId = tableData.last['id'];
      final saveData = {
        'id': (lastId + 1),
        ...data
      };
      tableData.add(saveData);
    }

    _databaseSave();
  }

  void _databaseSave() =>
      File('database.json').writeAsStringSync(jsonEncode(_database));

  void delete(String table, int id) {
    final databaseData = getAll(table);
    databaseData.removeWhere((element) => element['id'] == id);
    _databaseSave();
  }
}
