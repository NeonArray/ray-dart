import 'dart:io';

import 'package:ray_dart/src/client.dart';
import 'package:ray_dart/src/payload_factory.dart';
import 'package:ray_dart/src/payloads/custom_payload.dart';
import 'package:ray_dart/src/payloads/payload.dart';
import 'package:ray_dart/src/request.dart';
import 'package:ray_dart/src/settings/ray_settings.dart';
import 'package:ray_dart/src/support/rate_limiter.dart';
import 'package:uuid/uuid.dart';

class Ray {
  late RaySettings settings;
  late String uuid;
  late Client client;
  late RateLimiter rateLimiter;
  bool enabled = true;
  List<Stopwatch> stopWatches = [];
  bool canSendPayload = true;

  static String projectName = '';
  static List<dynamic> counters = [];
  static List<dynamic> limiters = [];

  Ray({
    RaySettings? settings,
    Client? client,
    String? uuid,
    RateLimiter? rateLimiter,
  }) {
    this.settings = settings ?? RaySettings({});
    this.client = client ?? Client();
    this.uuid = uuid ?? Uuid().v4();
    this.rateLimiter = rateLimiter ?? RateLimiter.disabled();
  }

  factory Ray.create(Client? client, String? uuid) => Ray(
        settings: RaySettings.createFromConfigFile(),
        client: client,
        uuid: uuid,
      );

  static setClient(Client client) {
    client = client;
  }

  void send(dynamic args) {
    if (args is List && args.isEmpty) {
      return;
    }

    sendRequest(PayloadFactory(args).createPayloads());
  }

  void sendRequest(Object payloads) {
    if (!enabled || !canSendPayload) {
      return;
    }

    List<Payload> finalPayloads = [];
    if (payloads is List<Payload>) {
      if (payloads.isEmpty) {
        throw ArgumentError('Payloads are empty');
      }
      finalPayloads = payloads;
    } else if (payloads is Payload) {
      finalPayloads = [payloads];
    } else {
      throw ArgumentError('Unsupported type');
    }

    if (rateLimiter.isMaxReached() || rateLimiter.isMaxPerSecondReached()) {
      notifyWhenRateLimitReached();
      return;
    }

    for (var payload in finalPayloads) {
      payload.remotePath = Platform.localHostname;
      payload.localPath = '';
    }

    var request = Request(
      uuid: uuid,
      payloads: finalPayloads,
      meta: [
        {
          "dart_version": Platform.version,
        }
      ],
    );

    client.send(request);

    rateLimiter.hit();
  }

  void notifyWhenRateLimitReached() {
    if (rateLimiter.notified) {
      return;
    }

    var payload = CustomPayload('Rate limit has been reached', 'Rate Limit');
    var request = Request(uuid: uuid, payloads: [payload], meta: []);
    send(request);
    rateLimiter.notify();
  }
}
