import 'dart:convert';

import 'package:ray_dart/src/argument_converter.dart';
import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class DecodedJsonPayload extends Payload {
  final String value;

  DecodedJsonPayload(this.value);

  @override
  String getType() {
    return 'custom';
  }

  @override
  PayloadContent getContent() {
    final decodedJson = jsonDecode(value);
    return {
      'content': convertToPrimitive(decodedJson),
      'label': '',
    };
  }
}
