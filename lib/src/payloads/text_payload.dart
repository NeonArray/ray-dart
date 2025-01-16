import 'dart:convert';

import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class TextPayload extends Payload {
  final String text;

  TextPayload(this.text);

  @override
  String getType() {
    return 'custom';
  }

  @override
  PayloadContent getContent() {
    return {
      'content': formatContent(),
      'label': 'Text',
    };
  }

  String formatContent() {
    String result = HtmlEscape(HtmlEscapeMode.element).convert(text);
    return result.replaceAll(' ', '&nbsp;').replaceAll('\n', '<br />');
  }
}
