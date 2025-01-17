import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class NotifyPayload extends Payload {
  final String _text;

  NotifyPayload(this._text);

  @override
  String getType() {
    return 'notify';
  }

  @override
  PayloadContent getContent() {
    return {
      'value': _text,
    };
  }
}
