import 'package:meta/meta.dart';
import 'package:ray_dart/src/support/cache_store.dart';

class RateLimiter {
  @protected
  int maxCalls;

  @protected
  int maxPerSecond;

  @protected
  CacheStore? cache;

  bool notified = false;

  RateLimiter({
    this.maxCalls = -1,
    this.maxPerSecond = -1,
    CacheStore? cacheStore,
  });

  static RateLimiter disabled() {
    return RateLimiter(maxCalls: -1, maxPerSecond: -1, cacheStore: null);
  }

  void hit() {
    cache?.hit();
  }

  bool isMaxReached() {
    if (cache == null) {
      return false;
    }

    if (maxCalls == -1) {
      return false;
    }

    var reached = cache!.count() >= maxCalls;

    if (!reached) {
      notified = false;
    }

    return reached;
  }

  bool isMaxPerSecondReached() {
    if (cache == null) {
      return false;
    }

    if (maxPerSecond == -1) {
      return false;
    }

    var reached = cache!.countLastSecond() >= maxPerSecond;

    if (!reached) {
      notified = false;
    }

    return reached;
  }

  void clear() {
    maxCalls = -1;
    maxPerSecond = -1;
    cache?.clear();
  }

  void notify() {
    notified = true;
  }
}
