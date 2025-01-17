import 'package:meta/meta.dart';
import 'package:ray_dart/src/argument_converter.dart';
import 'package:ray_dart/src/payloads/bool_payload.dart';
import 'package:ray_dart/src/payloads/log_payload.dart';
import 'package:ray_dart/src/payloads/null_payload.dart';
import 'package:ray_dart/src/payloads/payload.dart';

final class PayloadFactory {
  final List _values;

  PayloadFactory(this._values);

  List<Payload> createPayloads() {
    return _values.map((value) {
      return _getPayload(value);
    }).toList();
  }

  @protected
  Payload _getPayload(dynamic value) {
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
