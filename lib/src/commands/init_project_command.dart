import 'dart:developer';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:json_rest_server/src/core/templates/template_utils.dart';
import 'package:json_rest_server/src/exceptions/command_exception.dart';

class InitProjectCommand extends Command {
  @override
  String get description => 'Initial project';

  @override
  String get name => 'init';

  @override
  void run() {
    try {
      var dirServer = _createFolder();
      _createDatabase(dirServer);
      _createConfig(dirServer);
      log('Backend Created');
      log('use json_rest_server run for start project');
    } on CommandException catch (e) {
      log(e.message);
    }
  }

  Directory _createFolder() {
    final args = argResults?.arguments;
    var path = '.';

    if (args != null) {
      path = args[0];
    }

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
    final databaseString = TemplateUtils().readTemplate(TemplateType.database);
    var db = File('${dir.path}/database.json');
    db.createSync(recursive: true);
    db.writeAsStringSync(databaseString);
  }
  
  void _createConfig(Directory dir) {
    
    final databaseString = TemplateUtils().readTemplate(TemplateType.config);
    var db = File('${dir.path}/config.yaml');
    db.createSync(recursive: true);
    db.writeAsStringSync(databaseString);
  }
}
