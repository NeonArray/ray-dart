import 'dart:convert';

import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class Request {
  final String uuid;
  final List<Payload> payloads;
  final PayloadMeta meta;

  Request({required this.uuid, required this.payloads, required this.meta});

  Map<String, dynamic> toMap() {
    final payload = _payloadsToListOfMaps(payloads);

    return {
      'uuid': uuid,
      'payloads': payload,
      'meta': meta,
    };
  }

  String toJson() {
    return json.encode(toMap());
  }

  List<Map<String, dynamic>> _payloadsToListOfMaps(List<Payload> payloads) {
    return payloads.map((payload) {
      return payload.toMap();
    }).toList();
  }
}
