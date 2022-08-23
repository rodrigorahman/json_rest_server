import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:yaml/yaml.dart';

class VersionCommand extends Command<dynamic> {
  @override
  String get description => 'Show json rest server version';

  @override
  String get name => 'version';

  @override
  void run() {
    final f = File("pubspec.yaml");
    final yamlStr = f.readAsStringSync();
    final yaml = loadYaml(yamlStr);
    print('');
    print('''
     ██╗███████╗ ██████╗ ███╗   ██╗    ██████╗ ███████╗███████╗████████╗    ███████╗███████╗██████╗ ██╗   ██╗███████╗██████╗ 
     ██║██╔════╝██╔═══██╗████╗  ██║    ██╔══██╗██╔════╝██╔════╝╚══██╔══╝    ██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗
     ██║███████╗██║   ██║██╔██╗ ██║    ██████╔╝█████╗  ███████╗   ██║       ███████╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝
██   ██║╚════██║██║   ██║██║╚██╗██║    ██╔══██╗██╔══╝  ╚════██║   ██║       ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗
╚█████╔╝███████║╚██████╔╝██║ ╚████║    ██║  ██║███████╗███████║   ██║       ███████║███████╗██║  ██║ ╚████╔╝ ███████╗██║  ██║
 ╚════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═══╝    ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝       ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝                                                                                                                             
    ''');
    print('Version: ${yaml['version']}');
  }
}


// VersionCommand() : super('version', 'Show json rest server version');
  
//   @override
//   Future run(Iterable<String> args) async {

//     return super.run(args);
  