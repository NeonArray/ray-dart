import 'package:ray_dart/src/payloads/payload.dart';

final class HidePayload extends Payload {
  @override
  String getType() {
    return 'hide';
  }
}
