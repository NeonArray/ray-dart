class StopExecutionRequested extends Error {
  final Object? message;

  StopExecutionRequested([this.message]);
}
