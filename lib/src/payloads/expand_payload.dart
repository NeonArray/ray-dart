import 'dart:math';

import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class ExpandPayload extends Payload {
  List<String> keys = [];
  int level = 0;

  ExpandPayload([List<dynamic> values = const []]) {
    for (var value in values) {
      if (_isNumeric(value)) {
        level = max(level, value);
      }

      keys.add(value);
    }
  }

  bool _isNumeric(dynamic value) {
    if (value == null) {
      return false;
    }

    return double.tryParse(value) != null;
  }

  @override
  String getType() {
    return 'expand';
  }

  @override
  PayloadContent getContent() {
    return {
      'keys': keys,
      'label': label,
    };
  }
}
