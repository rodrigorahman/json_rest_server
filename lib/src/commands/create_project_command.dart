import 'dart:io';

import 'package:args/command_runner.dart';

import '../core/exceptions/command_exception.dart';
import '../core/templates/templates.dart';

class CreateProjectCommand extends Command {
  @override
  String get description => 'create project';

  @override
  String get name => 'create';

  @override
  void run() {
    try {
      var dirServer = _createFolder();
      _createDirStorage(dirServer);
      _createDatabase(dirServer);
      _createConfig(dirServer);
      print('Backend Created');
      print('use json_rest_server run for start project');
    } on CommandException catch (e) {
      print(e.message);
    }
  }

  Directory _createFolder() {
    final path = switch (argResults?.arguments) {
      List(isNotEmpty: true, :var first) => first,
      _ => './'
    };

    var dir = Directory(path);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    } else {
      if (dir.listSync().isNotEmpty) {
        throw CommandException(message: 'Folder must be empty!');
      }
    }
    return dir;
  }

  void _createDatabase(Directory dir) {
    var db = File('${dir.path}/database.json');
    db.createSync(recursive: true);
    db.writeAsStringSync(TemplateType.database.templateBody);
  }

  void _createConfig(Directory dir) {
    var db = File('${dir.path}/config.yaml');
    db.createSync(recursive: true);
    db.writeAsStringSync(TemplateType.config.templateBody);
  }

  void _createDirStorage(Directory dirServer) {
    final dirStorage = Directory('${dirServer.path}/storage');
    dirStorage.create(recursive: true);
  }
}
