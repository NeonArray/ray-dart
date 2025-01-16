import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class NewScreenPayload extends Payload {
  String name;

  NewScreenPayload(this.name);

  @override
  String getType() {
    return 'new_screen';
  }

  @override
  PayloadContent getContent() {
    return {
      'name': name,
    };
  }
}
