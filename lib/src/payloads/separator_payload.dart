import 'package:ray_dart/src/payloads/payload.dart';

final class SeparatorPayload extends Payload {
  @override
  String getType() {
    return 'separator';
  }
}
