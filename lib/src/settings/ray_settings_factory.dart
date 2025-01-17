import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:ray_dart/src/settings/ray_settings.dart';

final class RaySettingsFactory {
  static Map<String, dynamic> cache = {};

  static RaySettings createFromMap([Map<String, dynamic> settings = const {}]) {
    return RaySettings(settings);
  }

  static RaySettings createFromConfigFile([String configDirectory = '']) {
    final settingsValues =
        RaySettingsFactory().getSettingsFromConfigFile(configDirectory);
    var settings = createFromMap(settingsValues);

    return settings;
  }

  Map<String, dynamic> getSettingsFromConfigFile(
      [String configDirectory = '']) {
    var configFilePath = _searchConfigFiles(configDirectory);

    if (!File(configFilePath).existsSync()) {
      return {};
    }

    var data = File(configFilePath).readAsStringSync();
    Map<String, dynamic> dataStruct = {};

    try {
      dataStruct = jsonDecode(data);
    } catch (e) {
      print(e);
      rethrow;
    }

    return dataStruct;
  }

  @protected
  String _searchConfigFiles([String configDirectory = '']) {
    if (!RaySettingsFactory.cache.containsKey(configDirectory)) {
      RaySettingsFactory.cache[configDirectory] =
          _searchConfigFilesOnDisk(configDirectory);
    }

    return RaySettingsFactory.cache[configDirectory];
  }

  @protected
  String _searchConfigFilesOnDisk([String configDirectory = '']) {
    var configNames = [
      'ray.json',
    ];

    if (configDirectory == '') {
      configDirectory = Directory.current.path;
    }

    while (Directory(configDirectory).existsSync()) {
      for (var configName in configNames) {
        var configFullPath =
            '$configDirectory${Platform.pathSeparator}$configName';
        if (File(configFullPath).existsSync()) {
          return configFullPath;
        }
      }

      var parentDirectory = Directory(configDirectory).parent.path;
      if (parentDirectory == configDirectory) {
        return '';
      }

      configDirectory = parentDirectory;
    }

    return '';
  }
}
