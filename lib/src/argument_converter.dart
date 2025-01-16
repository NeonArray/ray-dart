class ArgumentConverter {
  static dynamic convertToPrimitive(dynamic argument) {
    if (argument == null) {
      return null;
    }

    if (argument is String) {
      return argument;
    }

    if (argument is int) {
      return argument;
    }

    if (argument is bool) {
      return argument;
    }

    return argument.toString();
  }
}
