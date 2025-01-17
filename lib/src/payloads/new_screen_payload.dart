import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class NewScreenPayload extends Payload {
  final String _name;

  NewScreenPayload(this._name);

  @override
  String getType() {
    return 'new_screen';
  }

  @override
  PayloadContent getContent() {
    return {
      'name': _name,
    };
  }
}
