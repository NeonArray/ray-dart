import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class CustomPayload extends Payload {
  final String textContent;

  CustomPayload(this.textContent, String label) {
    this.label = label;
  }

  @override
  String getType() {
    return 'custom';
  }

  @override
  PayloadContent getContent() {
    return {
      'content': textContent,
      'label': label,
    };
  }
}
