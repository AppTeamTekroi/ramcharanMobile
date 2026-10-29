class Failure {
  final int statusCode;
  final String message;
  final Object? error;
  final StackTrace? stacktrace;

  Failure({
    required this.statusCode,
    required this.message,
    this.error,
    this.stacktrace,
  });
}
