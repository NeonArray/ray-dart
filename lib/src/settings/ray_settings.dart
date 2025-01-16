final class RaySettings {
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

  RaySettings _setDefaultSettings(Map<String, dynamic> defaults) {
    defaults.forEach((key, value) {
      if (_wasLoadedUsingConfigFile(key)) {
        settings[key] = value;
      }
    });

    return this;
  }

  bool _wasLoadedUsingConfigFile(String name) {
    if (settings[name] != null) {
      return true;
    }

    if (!_loadedUsingSettingsFile) {
      return true;
    }

    return false;
  }

  RaySettings _markAsLoadedUsingSettingsFile() {
    _loadedUsingSettingsFile = true;
    return this;
  }
}
