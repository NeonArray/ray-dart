import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class ConfettiPayload extends Payload {
  ConfettiPayload();

  @override
  String getType() {
    return 'confetti';
  }

  @override
  PayloadContent getContent() {
    return {};
  }
}
