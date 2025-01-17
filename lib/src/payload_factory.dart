import 'package:ray_dart/src/argument_converter.dart';
import 'package:ray_dart/src/payloads/bool_payload.dart';
import 'package:ray_dart/src/payloads/log_payload.dart';
import 'package:ray_dart/src/payloads/null_payload.dart';
import 'package:ray_dart/src/payloads/payload.dart';

class PayloadFactory {
  List values = [];
  final List _values;

  PayloadFactory(this._values);

  static List createForValues(List<dynamic> arguments) {
    return PayloadFactory(arguments).getPayloads();
  }
  List<Payload> createPayloads() {
    return _values.map((value) {
    }).toList();
  }

  Payload getPayload(dynamic value) {
    if (value == null) {
      return NullPayload();
    }

    if (value is bool) {
      return BoolPayload(value);
    }

    return LogPayload(
      convertToPrimitive(value),
      value,
    );
  }
}
