import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class CreateLockPayload extends Payload {
  final String name;

  CreateLockPayload(this.name);

  @override
  String getType() {
    return 'create_lock';
  }

  @override
  PayloadContent getContent() {
    return {
      'name': name,
    };
  }
}
