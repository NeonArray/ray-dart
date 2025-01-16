import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class LabelPayload extends Payload {
  LabelPayload(String label) {
    this.label = label;
  }

  @override
  String getType() {
    return 'label';
  }

  @override
  PayloadContent getContent() {
    return {
      'label': label,
    };
  }
}
