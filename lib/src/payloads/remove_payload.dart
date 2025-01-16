import 'package:ray_dart/src/payloads/payload.dart';

final class RemovePayload extends Payload {
  @override
  String getType() {
    return 'remove';
  }
}
