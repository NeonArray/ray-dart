import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class ScreenColorPayload extends Payload {
  String color;

  ScreenColorPayload(this.color);

  @override
  String getType() {
    return 'screen_color';
  }

  @override
  PayloadContent getContent() {
    assert(color != '', 'Color shouldn\'t be an empty string.');

    return {
      'color': color,
    };
  }
}
