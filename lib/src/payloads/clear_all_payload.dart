import 'package:ray_dart/src/payloads/payload.dart';

final class ClearAllPayload extends Payload {
  @override
  String getType() {
    return 'clear_all';
  }
}
