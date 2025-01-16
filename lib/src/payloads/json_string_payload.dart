import 'dart:convert';

import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class JsonStringPayload extends Payload {
  final dynamic value;

  JsonStringPayload(this.value);

  @override
  String getType() {
    return 'json_string';
  }

  @override
  PayloadContent getContent() {
    return {
      'value': jsonEncode(value),
    };
  }
}
