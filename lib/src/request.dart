import 'dart:convert';

import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class Request {
  final String uuid;
  final List<Payload> payloads;
  final PayloadMeta meta;

  Request({required this.uuid, required this.payloads, required this.meta});

  Map<String, dynamic> toMap() {
    var payload = payloads.map((payload) {
      var item = payload.toMap();
      // item.removeWhere((key, value) => value == null);
      return item;
    }).toList();

    return {
      'uuid': uuid,
      'payloads': payload,
      'meta': meta,
    };
  }

  String toJson() {
    return json.encode(toMap());
  }
}
