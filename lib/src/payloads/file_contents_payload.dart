import 'dart:convert';
import 'dart:io';

import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class FileContentsPayload extends Payload {
  final String filePath;

  FileContentsPayload(this.filePath);

  @override
  String getType() {
    return 'custom';
  }

  @override
  PayloadContent getContent() {
    var file = File(filePath);

    if (!file.existsSync()) {
      return {
        'content': "File not found: '$filePath'",
        'label': 'File',
      };
    }

    return {
      'content': _encodeContent(file.readAsStringSync()),
      'label': filePath.split(Platform.pathSeparator).last,
    };
  }

  String _encodeContent(String content) {
    String result = HtmlEscape(HtmlEscapeMode.element).convert(content);
    return result.replaceAll('\n', '<br />');
  }
}
