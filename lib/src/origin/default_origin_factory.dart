import 'package:ray_dart/src/origin/hostname.dart';
import 'package:ray_dart/src/origin/origin.dart';
import 'package:ray_dart/src/origin/origin_factory.dart';
import 'package:stack_trace/stack_trace.dart';

class DefaultOriginFactory extends OriginFactory {
  @override
  Origin getOrigin() {
    Frame frame = getFrame();
    return Origin(
      frame.uri.path,
      frame.line.toString(),
      Hostname.get(),
    );
  }

  Frame getFrame() {
    List<Frame> frames = Chain.current().toTrace().frames;
    var index = _getIndexOfRayFrame(frames);
    return frames[index];
  }

  // void getAllFames() {}

  int _getIndexOfRayFrame(List<Frame> frames) {
    var index = _search<Frame>((Frame frame) {
      if (frame.uri.path.startsWith('package:ray_dart/')) {
        return false;
      }

      return true;
    }, frames);

    return index;
  }

  int _search<T>(
    bool Function(T item) callable,
    List<T> items,
  ) {
    for (var entry in items) {
      if (callable(entry)) {
        return items.indexOf(entry);
      }
    }
    return -1;
  }
}
