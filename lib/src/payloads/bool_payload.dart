import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class BoolPayload extends Payload {
  final bool _boolValue;

  BoolPayload(this._boolValue);

  @override
  String getType() {
    return 'custom';
  }

  @override
  PayloadContent getContent() {
    return {
      'content': _boolValue,
      'label': 'Boolean',
    };
  }
}
