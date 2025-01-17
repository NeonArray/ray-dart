final class RaySettings {
  static Map<String, String> cache = {};
  Map<String, dynamic> settings = {};
  bool _loadedUsingSettingsFile = false;
  final Map<String, dynamic> _defaultSettings = {
    'enable': true,
    'host': 'localhost',
    'port': 23517,
    'remote_path': null,
    'local_path': null,
    'always_send_raw_values': false,
  };

  RaySettings(Map<String, dynamic> settings) {
    this.settings = {..._defaultSettings, ...settings};
  }

  factory RaySettings.createFromMap(
      [Map<String, dynamic> settings = const {}]) {
    return RaySettings(settings);
  }

  factory RaySettings.createFromConfigFile([String configDirectory = '']) {
    final settingsValues =
        RaySettings.getSettingsFromConfigFile(configDirectory);
    return RaySettings.createFromMap(settingsValues);
  }

  void setDefaultSettings(Map<String, dynamic> defaults) {
    defaults.forEach((key, value) {
      if (wasLoadedUsingConfigFile(key)) {
        settings[key] = value;
      }
    });
  }

  bool wasLoadedUsingConfigFile(String name) {
    if (settings[name] != null) {
      return true;
    }

    if (!_loadedUsingSettingsFile) {
      return true;
    }

    return false;
  }

  void markAsLoadedUsingSettingsFile() {
    _loadedUsingSettingsFile = true;
  }

  static Map<String, dynamic> getSettingsFromConfigFile(
      [String configDirectory = '']) {
    final configFilePath = RaySettings.searchConfigFiles(configDirectory);

    if (configFilePath == null) {
      return {};
    }

    if (!File(configFilePath).existsSync()) {
      return {};
    }

    try {
      final data = File(configFilePath).readAsStringSync();
      return jsonDecode(data);
    } catch (e) {
      rethrow;
    }
  }

  static String? searchConfigFiles([String configDirectory = '']) {
    if (!RaySettings.cache.containsKey(configDirectory)) {
      RaySettings.cache[configDirectory] =
          searchConfigFilesOnDisk(configDirectory);
    }

    return RaySettings.cache[configDirectory];
  }

  static String searchConfigFilesOnDisk([String configDirectory = '']) {
    // TODO: Possibly handle other types such as a dart Map
    final configNames = [
      'ray.json',
    ];

    if (configDirectory == '') {
      configDirectory = Directory.current.path;
    }

    while (Directory(configDirectory).existsSync()) {
      for (var configName in configNames) {
        final configFullPath =
            '$configDirectory${Platform.pathSeparator}$configName';
        if (File(configFullPath).existsSync()) {
          return configFullPath;
        }
      }

      final parentDirectory = Directory(configDirectory).parent.path;
      if (parentDirectory == configDirectory) {
        return '';
      }

      configDirectory = parentDirectory;
    }

    return '';
  }
}
