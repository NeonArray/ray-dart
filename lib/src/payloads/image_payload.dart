import 'dart:convert';
import 'dart:io';

import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class ImagePayload extends Payload {
  String location;

  ImagePayload(this.location);

  @override
  String getType() {
    return 'custom';
  }

  @override
  PayloadContent getContent() {
    var file = File(location);

    if (file.existsSync()) {
      location = 'file://$location';
    }

    if (_hasBase64Data()) {
      location = _getLocationForBase64Data();
    }

    location = location.replaceAll('"', '');

    return {
      'content': '<img src="$location" alt="" />',
      'label': 'Image',
    };
  }

  String _stripDataPrefix(String data) {
    return data.replaceFirst(RegExp(r'^data:image/[a-z]+;base64,'), '');
  }

  bool _hasBase64Data() {
    var data = _stripDataPrefix(location);
    try {
      return base64Encode(base64Decode(data)) == data;
    } catch (e) {
      return false;
    }
  }

  String _getLocationForBase64Data() {
    return 'data:image/png;base64,${_stripDataPrefix(location)}';
  }
}
