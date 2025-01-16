import 'package:ray_dart/src/payloads/payload.dart';

final class ColorPayload extends Payload {
  String color;

  ColorPayload(this.color);

  @override
  String getType() {
    return 'color';
  }

  @override
  Map<String, dynamic> getContent() {
    return {
      'color': color,
    };
  }
}
