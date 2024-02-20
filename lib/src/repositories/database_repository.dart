import 'dart:convert';
import 'dart:io';

import 'package:json_rest_server/src/core/enum/id_type_enum.dart';
import 'package:json_rest_server/src/core/exceptions/conflict_id_exception.dart';
import 'package:json_rest_server/src/core/exceptions/resource_notfound_exception.dart';
import 'package:json_rest_server/src/models/config_model.dart';
import 'package:uuid/uuid.dart';

class DatabaseRepository {
  final ConfigModel _configModel;
  late Map<String, dynamic> _database;

  DatabaseRepository(this._configModel);

  void load(String basePath) {
    final databaseFile = File('${basePath}database.json');

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

  Map<String, dynamic>? update(String table, Map<String, dynamic> data) {
    final {'id': id} = data;

    if (id == null) {
      throw ResourceNotfoundException();
    }
    final lineData = getById(table, id);

    if (lineData.isEmpty) {
      throw ResourceNotfoundException();
    }

    return save(table, data);
  }

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
      saveData = {...lineData};
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
      final hasIntegerValue =
          tableData.indexWhere((table) => table['id'] is int);
      if (hasIntegerValue != -1) {
        throw ConflictIdException(
            message:
                'Your id pattern not UUID String value. Please ensure that you didn\'t change idType in the middle of your operation');
      }
      return Uuid().v1();
    }
    var lastId = 0;
    if (tableData.isNotEmpty) {
      final hasStringValue =
          tableData.indexWhere((table) => table['id'] is String);
      if (hasStringValue != -1) {
        throw ConflictIdException(
            message:
                'Your id pattern not integer value. Please ensure that you didn\'t change idType in the middle of your operation');
      }
      lastId = tableData.last['id'] ?? 0;
    }
    return lastId + 1;
  }
}
