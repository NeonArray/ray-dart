import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class SizePayload extends Payload {
  String size;

  SizePayload(this.size);

  @override
  String getType() {
    return 'size';
  }

  @override
  PayloadContent getContent() {
    return {
      'size': size,
    };
  }
}
