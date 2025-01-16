import 'dart:convert';
import 'dart:mirrors';

class PlainTextDumper {
  static List<Object?> _objects = [];
  static String _output = '';
  static int _depth = 0;

  /// Converts a variable into a string representation.
  /// @param var variable to be dumped
  /// @param depth maximum depth that the dumper should go into the variable. Defaults to 10.
  /// @return the string representation of the variable
  static String dump(dynamic variable, [int depth = 5]) {
    _output = '';
    _objects = [];
    _depth = depth;
    _dumpInternal(variable, 0);
    return _output;
  }

  static void _dumpInternal(dynamic variable, int level) {
    if (level > _depth) {
      _output += '...';
      return;
    }

    if (variable == null) {
      _output += 'null';
    } else if (variable is bool) {
      _output += variable ? 'true' : 'false';
    } else if (variable is num) {
      _output += variable.toString();
    } else if (variable is String) {
      _output += "'${variable.replaceAll("'", "\\'")}'";
    } else if (variable is List || variable is Set) {
      if (level >= _depth) {
        _output += '[...]';
      } else {
        var iterable = variable as Iterable;
        _output += '[';
        for (var item in iterable) {
          _dumpInternal(item, level + 1);
          _output += ', ';
        }
        _output += ']';
      }
    } else if (variable is Map) {
      if (level >= _depth) {
        _output += '{...}';
      } else {
        _output += '{';
        for (var entry in variable.entries) {
          _dumpInternal(entry.key, level + 1);
          _output += ': ';
          _dumpInternal(entry.value, level + 1);
          _output += ', ';
        }
        _output += '}';
      }
    } else if (variable is Object) {
      int id = _objects.indexOf(variable);
      if (id != -1) {
        _output += '${variable.runtimeType}#${id + 1}(...)';
      } else if (level >= _depth) {
        _output += '${variable.runtimeType}(...)';
      } else {
        _objects.add(variable);
        id = _objects.length;
        _output += '${variable.runtimeType}#$id {\n';
        var asMap =
            variable.toJson(); // Assuming the object has a toJson method
        asMap.forEach((key, value) {
          _output += '  ' * (level + 1) + '$key: ';
          _dumpInternal(value, level + 1);
          _output += ',\n';
        });
        _output += '  ' * level + '}';
      }
    }
  }
}

extension on Object {
  toJson() {
    if (this is Map ||
        this is List ||
        this is String ||
        this is num ||
        this is bool) {
      return jsonEncode(this);
    } else {
      // Attempt to convert to a Map using reflection (limited)
      try {
        final mirror = reflect(this);
        final Map<String, dynamic> jsonMap = {};
        for (final declaration in mirror.type.declarations.values) {
          if (declaration is VariableMirror && !declaration.isPrivate) {
            final name = MirrorSystem.getName(declaration.simpleName);
            final value = mirror.getField(declaration.simpleName).reflectee;
            jsonMap[name] = value;
          }
        }
        return jsonEncode(jsonMap);
      } catch (e) {
        return jsonEncode(toString());
      }
    }
  }
}
