import 'dart:convert';
import 'dart:io';

import 'package:ray_dart/src/support/types.dart';

abstract base class Payload {
  String? type;
  String? label;
  PayloadContent? content;
  PayloadMeta? meta;
  String? remotePath;
  String? localPath;

  String getType();

  PayloadContent getContent() {
    return {};
  }

  Map<String, dynamic> toMap() {
    return {
      'type': getType(),
      'content': getContent(),
      "origin": {
        ...originCallerInfo(),
        "hostname": Platform.localHostname,
      },
    };
  }

  Map<String, dynamic> originCallerInfo() {
    String functionName = '';
    String fileName = '';
    int lineNumber = 0;

    // Get the current stack trace
    StackTrace current = StackTrace.current;

    // Convert the stack trace to a list of strings
    List<String> lines = current.toString().split('\n');

    if (lines.length > 1) {
      // find the first item AFTER the internal call to ray
      int index =
          lines.indexWhere((line) => RegExp(r'#\d+\s+ray').hasMatch(line));

      if (index != -1) {
        final caller = lines[index + 1];
        final stacktraceLineInfo =
            RegExp(r'#\d+\s+([^\s]+) \((.*?):(\d+):(\d+)\)');
        final match = stacktraceLineInfo.firstMatch(caller);

        if (match != null) {
          functionName = match.group(1) ?? 'Unknown function';
          fileName = match.group(2) ?? 'Unknown file';
          lineNumber = int.parse(match.group(3) ?? '0');
        }
      }
    }

    return {
      'function_name': functionName,
      'file': fileName,
      'line_number': lineNumber,
    };
  }

  String toJson() {
    return json.encode(toMap());
  }
}
