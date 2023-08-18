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

  Map<String, dynamic>? save(String table, Map<String, dynamic> data) {
    final id = data['id'];
    var saveData = <String, dynamic>{};
    var lineData = <String, dynamic>{};
    if (id != null) {
      lineData = getById(table, id);
    }

    if (lineData.isNotEmpty) {
      for (var entry in data.entries) {
        lineData.update(
          entry.key,
          (value) => entry.value,
          ifAbsent: () => entry.value,
        );
      }
    } else {
      final bodyData = {...data};
      bodyData.remove('id');
      final tableData = getAll(table);
      var lastId = 0;

      if (tableData.isNotEmpty) {
        lastId = tableData.last['id'] ?? 0;
      }
      saveData = {'id': (lastId + 1), ...bodyData};
      tableData.add(saveData);
    }
    _databaseSave();
    return saveData;
  }

  void _databaseSave() =>
      File('database.json').writeAsStringSync(jsonEncode(_database));

  void delete(String table, int id) {
    final databaseData = getAll(table);
    databaseData.removeWhere((element) => element['id'] == id);
    _databaseSave();
  }
}
