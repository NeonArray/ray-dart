import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:ray_dart/src/payloads/clear_all_payload.dart';
import 'package:ray_dart/src/payloads/color_payload.dart';
import 'package:ray_dart/src/payloads/confetti_payload.dart';
import 'package:ray_dart/src/payloads/create_lock_payload.dart';
import 'package:ray_dart/src/payloads/custom_payload.dart';
import 'package:ray_dart/src/payloads/decoded_json_payload.dart';
import 'package:ray_dart/src/payloads/expand_payload.dart';
import 'package:ray_dart/src/payloads/file_contents_payload.dart';
import 'package:ray_dart/src/payloads/hide_app_payload.dart';
import 'package:ray_dart/src/payloads/html_payload.dart';
import 'package:ray_dart/src/payloads/image_payload.dart';
import 'package:ray_dart/src/payloads/json_string_payload.dart';
import 'package:ray_dart/src/payloads/label_payload.dart';
import 'package:ray_dart/src/payloads/log_payload.dart';
import 'package:ray_dart/src/payloads/new_screen_payload.dart';
import 'package:ray_dart/src/payloads/notify_payload.dart';
import 'package:ray_dart/src/payloads/remove_payload.dart';
import 'package:ray_dart/src/payloads/screen_color_payload.dart';
import 'package:ray_dart/src/payloads/separator_payload.dart';
import 'package:ray_dart/src/payloads/show_app_payload.dart';
import 'package:ray_dart/src/payloads/size_payload.dart';
import 'package:ray_dart/src/payloads/table_payload.dart';
import 'package:ray_dart/src/payloads/text_payload.dart';
import 'package:ray_dart/src/ray.dart';
import 'package:ray_dart/src/support/types.dart';

extension Color on Ray {
  void color(String color) {
    sendRequest(ColorPayload(color));
  }
}

extension Enable on Ray {
  void enable() {
    enabled = true;
  }
}

extension Disable on Ray {
  void disable() {
    enabled = false;
  }
}

extension Project on Ray {
  void project(String projectName) {
    Ray.projectName = projectName;
  }
}

extension ClearScreen on Ray {
  void clearScreen() {
    sendRequest(ClearAllPayload());
  }
}

extension NewScreen on Ray {
  void newScreen(String name) {
    sendRequest(NewScreenPayload(name));
  }
}

extension ScreenColor on Ray {
  void screenColor(String color) {
    sendRequest(ScreenColorPayload(color));
  }
}

extension ShowApp on Ray {
  void showApp() {
    sendRequest(ShowAppPayload());
  }
}

extension HideApp on Ray {
  void hideApp() {
    sendRequest(HideAppPayload());
  }
}

extension Notify on Ray {
  void notify(String text) {
    sendRequest(NotifyPayload(text));
  }
}

extension Remove on Ray {
  void remove() {
    sendRequest(RemovePayload());
  }
}

extension Separator on Ray {
  void separator() {
    sendRequest(SeparatorPayload());
  }
}

extension Size on Ray {
  void size(String size) {
    sendRequest(SizePayload(size));
  }
}

extension Table on Ray {
  void table(List values, [String label = 'Table']) {
    sendRequest(TablePayload(values, label));
  }
}

extension Confetti on Ray {
  void confetti() {
    sendRequest(ConfettiPayload());
  }
}

extension CreateLock on Ray {
  void createLock(String name) {
    sendRequest(CreateLockPayload(name));
  }
}

extension File on Ray {
  void file(String filePath) {
    sendRequest(FileContentsPayload(filePath));
  }
}

extension Image on Ray {
  void image(String location) {
    sendRequest(ImagePayload(location));
  }
}

extension Html on Ray {
  void html([String html = '']) {
    sendRequest(HtmlPayload(html));
  }
}

extension Expand on Ray {
  void expand(List<dynamic> levelOrKey) {
    if (levelOrKey.isEmpty) {
      levelOrKey = [1];
    }
    sendRequest(ExpandPayload(levelOrKey));
  }
}

extension ToJson on Ray {
  void toJson(List<dynamic> jsons) {
    final payloads = jsons.map((j) => JsonStringPayload(j)).toList();
    sendRequest(payloads);
  }
}

extension Json on Ray {
  void json(List<String> jsons) {
    final payloads = jsons.map((j) => DecodedJsonPayload(j)).toList();
    sendRequest(payloads);
  }
}

extension SendCustom on Ray {
  void sendCustom(String content, [String label = '']) {
    sendRequest(CustomPayload(content, label));
  }
}

extension Label on Ray {
  void label(String label) {
    sendRequest(LabelPayload(label));
  }
}

extension Text on Ray {
  void text(String text) {
    sendRequest(TextPayload(text));
  }
}

extension OnlyIf on Ray {
  void onlyIf<T>(T boolOrCallable, [Function? callback]) {
    bool result = true;

    if (boolOrCallable is BoolCallable) {
      result = boolOrCallable();
    }

    if (boolOrCallable is bool && boolOrCallable && callback != null) {
      callback(this);
    }

    if (callback == null) {
      canSendPayload = result;
    }
  }
}

extension Url on Ray {
  void url(String url, [String label = '']) {
    if (!url.startsWith('http')) {
      url = 'https://$url';
    }

    if (label.isEmpty) {
      label = url;
    }

    var link = "<a href='$url'>$label</a>";
    html(link);
  }
}

extension Raw on Ray {
  void raw(List<dynamic> arguments) {
    if (arguments.isEmpty) {}

    var payloads = arguments.map((arg) {
      return LogPayload.createForArguments(arg);
    });

    sendRequest(payloads);
  }
}

/// TODO: Refactor
/// This method needs some thought. In order to poll the client this needs
/// to be a future async, but because of this requirement the method cant
/// be chained without wrapping and awaiting. This could be an issue
/// depending on the use-case of the consumer. Needs a solution.
extension Pause on Ray {
  Future<void> pause() async {
    var currentTime = DateTime.now().microsecondsSinceEpoch ~/ 1000;
    var timeString = currentTime.toString();
    var bytes = utf8.encode(timeString);
    var digest = md5.convert(bytes);

    sendRequest(CreateLockPayload(digest.toString()));

    do {
      sleep(Duration(milliseconds: 1000));
    } while (await client.lockExists(digest.toString()));
  }
}
