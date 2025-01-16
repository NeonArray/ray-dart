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
      _dumpNull();
    } else if (variable is bool) {
      _dumpBool(variable);
    } else if (variable is num) {
      _dumpNumber(variable);
    } else if (variable is String) {
      _dumpString(variable);
    } else if (variable is List || variable is Set) {
      _dumpIterable(level, variable);
    } else if (variable is Map) {
      _dumpMap(level, variable);
    } else if (variable is Object) {
      _dumpObject(variable, level);
    }
  }

  static void _dumpNull() {
    _output += 'null';
  }

  static void _dumpBool(bool variable) {
    _output += variable ? 'true' : 'false';
  }

  static void _dumpNumber(num variable) {
    _output += variable.toString();
  }

  static void _dumpString(String variable) {
    _output += "'${variable.replaceAll("'", "\\'")}'";
  }

  static void _dumpIterable(int level, variable) {
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
  }

  static void _dumpMap(int level, Map<dynamic, dynamic> variable) {
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
  }

  static void _dumpObject(Object variable, int level) {
    int? id = _objects.indexOf(variable);
    if (id != -1) {
      _output += '${variable.runtimeType}#${id + 1}(...)';
    } else if (_depth <= level) {
      _output += '${variable.runtimeType}(...)';
    } else {
      id = _objects.length;
      _objects.add(variable);
      String className = variable.runtimeType.toString();
      String spaces = ' ' * (level * 4);
      _output += "$className#$id\n$spaces(";

      try {
        final mirror = reflect(variable);
        final Map<String, dynamic> members = {};
        for (final declaration in mirror.type.declarations.values) {
          if (declaration is VariableMirror && !declaration.isPrivate) {
            final name = MirrorSystem.getName(declaration.simpleName);
            final value = mirror.getField(declaration.simpleName).reflectee;
            members[name] = value;
          }
        }
        members.forEach((key, value) {
          String keyDisplay = key.toString().replaceAll('\u0000', ':').trim();
          _output += "\n$spaces    [$keyDisplay] => ";
          _dumpInternal(value, level + 1);
        });
      } catch (e) {
        _output += "\n$spaces    Error: Could not access members";
      }
      _output += "\n$spaces)";
    }
  }
}
