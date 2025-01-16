import 'package:ray_dart/src/payloads/payload.dart';

final class HideAppPayload extends Payload {
  @override
  String getType() {
    return 'hide_app';
  }
}
