import 'package:ray_dart/src/payloads/payload.dart';

final class ColorPayload extends Payload {
  final String _color;

  ColorPayload(this._color);

  @override
  String getType() {
    return 'color';
  }

  @override
  Map<String, dynamic> getContent() {
    return {
      'color': _color,
    };
  }
}
