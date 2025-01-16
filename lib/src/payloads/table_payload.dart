import 'package:ray_dart/src/argument_converter.dart';
import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class TablePayload extends Payload {
  List<dynamic> values;

  TablePayload(this.values, [String? label]) {
    this.label = label;
  }

  @override
  String getType() {
    return 'table';
  }

  @override
  PayloadContent getContent() {
    final vals = values.map((value) {
      return ArgumentConverter.convertToPrimitive(value);
    }).toList();

    return {
      'values': vals,
      'label': label,
    };
  }
}
