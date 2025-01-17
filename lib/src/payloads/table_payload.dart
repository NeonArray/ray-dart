import 'package:ray_dart/src/argument_converter.dart';
import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class TablePayload extends Payload {
  final List<dynamic> _values;

  TablePayload(this._values, [String? label]) {
    this.label = label;
  }

  @override
  String getType() {
    return 'table';
  }

  @override
  PayloadContent getContent() {
    final vals = convertValuesToPrimitives(_values);

    return {
      'values': vals,
      'label': label,
    };
  }
}
