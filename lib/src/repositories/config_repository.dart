import 'dart:io';

import 'package:json_rest_server/src/core/exceptions/config_not_found_exception.dart';
import 'package:json_rest_server/src/models/config_model.dart';
import 'package:yaml/yaml.dart';

class ConfigRepository {
  ConfigModel load() {
    final basePath = String.fromEnvironment('debugPath', defaultValue: '');
    final configFile = File('${basePath}config.yaml');

    if (!configFile.existsSync()) {
      throw ConfigNotFoundException();
    }

    YamlMap confYaml = loadYaml(configFile.readAsStringSync());
    return ConfigModel.fromMap(confYaml.value.cast());
  }
}
