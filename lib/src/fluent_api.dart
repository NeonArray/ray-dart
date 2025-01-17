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
  /// Assign a color to a payload.
  void color(String color) {
    sendRequest(ColorPayload(color));
  }
}

extension Enable on Ray {
  /// Enable sending data to Ray.
  void enable() {
    enabled = true;
  }
}

extension Disable on Ray {
  /// Disable sending data to Ray.
  void disable() {
    enabled = false;
  }
}

extension Project on Ray {
  /// Set the project name.
  void project(String projectName) {
    Ray.projectName = projectName;
  }
}

extension ClearAll on Ray {
  /// Clear current and all previous screens.
  void clearAll() {
    sendRequest(ClearAllPayload());
  }
}

extension ClearScreen on Ray {
  /// Clear current screen.
  void clearScreen() {
    newScreen();
  }
}

extension NewScreen on Ray {
  /// Start a new screen.
  void newScreen([String name = '']) {
    sendRequest(NewScreenPayload(name));
  }
}

extension ScreenColor on Ray {
  void screenColor(String color) {
    sendRequest(ScreenColorPayload(color));
  }
}

extension ShowApp on Ray {
  /// Show the app.
  void showApp() {
    sendRequest(ShowAppPayload());
  }
}

extension HideApp on Ray {
  /// Hide the app.
  void hideApp() {
    sendRequest(HideAppPayload());
  }
}

extension Notify on Ray {
  /// Display a notification.
  void notify(String text) {
    sendRequest(NotifyPayload(text));
  }
}

extension Remove on Ray {
  /// Remove an item from Ray.
  void remove() {
    sendRequest(RemovePayload());
  }
}

extension Separator on Ray {
  /// Add a visual separator.
  void separator() {
    sendRequest(SeparatorPayload());
  }
}

extension Size on Ray {
  /// Display the size of a String.
  void size(String size) {
    sendRequest(SizePayload(size));
  }
}

extension Table on Ray {
  /// Format a List with optional label.
  void table(List values, [String label = 'Table']) {
    sendRequest(TablePayload(values, label));
  }
}

extension Confetti on Ray {
  /// Shoot confetti in the current screen.
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
  /// Display contents of a file.
  void file(String filePath) {
    sendRequest(FileContentsPayload(filePath));
  }
}

extension Image on Ray {
  /// Display an image using a path or url.
  void image(String location) {
    sendRequest(ImagePayload(location));
  }
}

extension Html on Ray {
  /// Render a piece of HTML.
  void html([String html = '']) {
    sendRequest(HtmlPayload(html));
  }
}

extension Expand on Ray {
  /// Send a value to Ray and immediately expand it.
  void expand(List<dynamic> levelOrKey) {
    if (levelOrKey.isEmpty) {
      levelOrKey = [1];
    }
    sendRequest(ExpandPayload(levelOrKey));
  }
}

extension ToJson on Ray {
  /// Display the JSON representation of 1 or more convertable values.
  void toJson(List<dynamic> jsons) {
    final payloads = jsons.map((j) => JsonStringPayload(j)).toList();
    sendRequest(payloads);
  }
}

extension Json on Ray {
  /// Send one or more valid JSON strings to Ray.
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
  /// Set the label name.
  void label(String label) {
    sendRequest(LabelPayload(label));
  }
}

extension Text on Ray {
  /// Display the raw text for a string while preserving whitespace fomatting.
  void text(String text) {
    sendRequest(TextPayload(text));
  }
}

extension OnlyIf on Ray {
  /// Conditionally show data based on truthy value or callable.
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
  /// Display a clickable URL in Ray.
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

extension Hide on Ray {
  /// Display data in Ray and immediately collapse it.
  void hide() {
    sendRequest(HideAppPayload());
  }
}

extension Pass on Ray {
  /// Display somethign in Ray and return the value.
  dynamic pass(dynamic argument) {
    sendRequest(argument);
    return argument;
  }
}
