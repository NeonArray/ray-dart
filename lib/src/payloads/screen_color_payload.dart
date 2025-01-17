import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class ScreenColorPayload extends Payload {
  final String _color;

  ScreenColorPayload(this._color);

  @override
  String getType() {
    return 'screen_color';
  }

  @override
  PayloadContent getContent() {
    return {
      'color': _color,
    };
  }
}
