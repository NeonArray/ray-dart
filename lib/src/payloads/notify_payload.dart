import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class NotifyPayload extends Payload {
  String text;

  NotifyPayload(this.text);

  @override
  String getType() {
    return 'notify';
  }

  @override
  PayloadContent getContent() {
    return {
      'value': text,
    };
  }
}
