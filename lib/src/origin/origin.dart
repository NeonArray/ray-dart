import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:ray_dart/src/origin/hostname.dart';

class Origin {
  String? file;
  String? lineNumber;
  String? hostName;

  Origin(this.file, this.lineNumber, this.hostName) {
    hostName ??= Hostname.get();
  }

  Map<String, dynamic> toMap() {
    return {
      'file': file,
      'line_number': lineNumber,
      'hostname': hostName,
    };
  }

  String fingerPrint() {
    final bytes = utf8.encode(toMap().toString());
    return md5.convert(bytes).toString();
  }
}
