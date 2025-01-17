import 'package:ray_dart/src/argument_converter.dart';
import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/plain_text_dumper.dart';
import 'package:ray_dart/src/support/types.dart';

final class LogPayload extends Payload {
  late List<dynamic> values;

  LogPayload(dynamic values, [dynamic rawValues = const []]) {
    if (values! is List) {
      if (values is int && values >= 11111111111111111) {
        this.values = [values.toString()];
      } else {
        this.values = [values];
      }
    }

    final data = _getClipboardData(rawValues);
    meta = [
      {
        'clipboard_data': data.substring(
          0,
          data.length.clamp(0, 20000),
        ),
      }
    ];

    this.values = [values];
  }

  @override
  PayloadContent getContent() {
    return {
      'values': values,
      'meta': meta,
    };
  }

  @override
  String getType() {
    return 'log';
  }

  static Payload createForArguments(List<dynamic> arguments) {
    final dumpedArgs = convertValuesToPrimitives(arguments);

    return LogPayload(dumpedArgs);
  }

  String _getClipboardData(dynamic value) {
    if (value is String || value is num) {
      return value.toString();
    }

    try {
      return PlainTextDumper.dump(value);
    } on Exception catch (_) {
      return '';
    }
  }
}
