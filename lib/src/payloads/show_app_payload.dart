import 'package:ray_dart/src/payloads/payload.dart';

final class ShowAppPayload extends Payload {
  @override
  String getType() {
    return 'show_app';
  }
}
