import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class NullPayload extends Payload {
  @override
  String getType() {
    return 'custom';
  }

  @override
  PayloadContent getContent() {
    return {
      'content': null,
      'label': 'Null',
    };
  }
}
