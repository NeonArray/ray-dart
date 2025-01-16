import 'dart:io';

class Hostname {
  static String? hostName;

  static String get() {
    return hostName ?? Platform.localHostname;
  }

  static set(String newHost) {
    hostName = newHost;
  }
}
