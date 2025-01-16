import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/support/types.dart';

final class HtmlPayload extends Payload {
  final String html;

  HtmlPayload(this.html);

  @override
  String getType() {
    return 'custom';
  }

  @override
  PayloadContent getContent() {
    return {
      'content': html,
      'label': 'HTML',
    };
  }
}
