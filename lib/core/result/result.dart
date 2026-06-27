/// A generic class that represents the result of an operation.
sealed class Result<T> {
  const Result();
}

/// Represents a successful operation result.
class Success<T> extends Result<T> {
  final T data;
  final int statusCode;
  final String message;

  const Success(
    this.data, {
    required this.statusCode,
    required this.message,
  });
}

/// Represents a failed operation result.
class Failure<T> extends Result<T> {
  final int? statusCode;
  final String message;

  const Failure({
    this.statusCode,
    required this.message,
  });

  /// Returns true if the status code is null.
  bool get isStatusCodeNull => statusCode == null;

  /// Returns true if the failure is due to an invalid request (HTTP 400-499).
  bool get isInvalidRequest =>
      statusCode != null && statusCode! >= 400 && statusCode! < 500;
}
