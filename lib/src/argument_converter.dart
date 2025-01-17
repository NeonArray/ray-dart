List convertValuesToPrimitives(Iterable values) {
  return values.map((value) {
    return convertToPrimitive(value);
  }).toList();
}

dynamic convertToPrimitive(dynamic argument) {
  if (argument == null) {
    return null;
  }

  if (argument is String) {
    return argument;
  }

  if (argument is num) {
    return argument;
  }

  if (argument is bool) {
    return argument;
  }

  return argument.toString();
}
