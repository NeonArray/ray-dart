import 'dart:convert';
import 'dart:io';

import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class ImagePayload extends Payload {
  final String _location;

  ImagePayload(this._location);

  @override
  String getType() {
    return 'custom';
  }

  @override
  PayloadContent getContent() {
    final file = File(_location);
    var url = '';

    if (file.existsSync()) {
      url = 'file://$_location';
    }

    if (_hasBase64Data()) {
      url = _getLocationForBase64Data();
    }

    url = _location.replaceAll('"', '');

    return {
      'content': '<img src="$url" alt="" />',
      'label': 'Image',
    };
  }

  String _stripDataPrefix(String data) {
    return data.replaceFirst(RegExp(r'^data:image/[a-z]+;base64,'), '');
  }

  bool _hasBase64Data() {
    final data = _stripDataPrefix(_location);
    try {
      return base64Encode(base64Decode(data)) == data;
    } catch (_) {
      return false;
    }
  }

  String _getLocationForBase64Data() {
    return 'data:image/png;base64,${_stripDataPrefix(_location)}';
  }
}
