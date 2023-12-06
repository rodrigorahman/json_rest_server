import 'dart:convert';
import 'dart:io';

import 'package:json_rest_server/src/models/config_model.dart';
import 'package:json_rest_server/src/core/enum/id_type_enum.dart';
import 'package:uuid/uuid.dart';

class DatabaseRepository {
  final ConfigModel _configModel;
  late Map<String, dynamic> _database;

  DatabaseRepository(this._configModel);

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

  Map<String, dynamic> getById(String table, dynamic id) => getAll(table)
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

      final lastId = _generateId(tableData);

      saveData = {'id': (lastId), ...bodyData};
      tableData.add(saveData);
    }
    _databaseSave();
    return saveData;
  }

  void _databaseSave() =>
      File('database.json').writeAsStringSync(jsonEncode(_database));

  void delete(String table, dynamic id) {
    final databaseData = getAll(table);
    databaseData.removeWhere((element) => element['id'] == id);
    _databaseSave();
  }

  dynamic _generateId(List<Map<String, dynamic>> tableData) {
    if (_configModel.idType == IdTypeEnum.uuid) {
      return Uuid().v1();
    }

    var lastId = 0;

    if (tableData.isNotEmpty) {
      lastId = tableData.last['id'] ?? 0;
    }
    return lastId + 1;
  }
}
