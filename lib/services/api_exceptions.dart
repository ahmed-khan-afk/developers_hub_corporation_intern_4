/// Base class for every error the [ApiService] can throw.
/// Keeping these typed (instead of throwing raw Strings/Exceptions)
/// lets the UI layer show a tailored message + icon for each case.
abstract class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

/// Thrown when the device has no internet connection / the request
/// timed out / a socket-level failure occurred.
class NoConnectionException extends ApiException {
  NoConnectionException([
    String message = 'No internet connection. Please check your network and try again.',
  ]) : super(message);
}

/// Thrown when the request took too long to complete.
class TimeoutApiException extends ApiException {
  TimeoutApiException([
    String message = 'The request timed out. The server took too long to respond.',
  ]) : super(message);
}

/// Thrown when the server responds with a non-2xx status code.
class ServerException extends ApiException {
  final int statusCode;
  ServerException(this.statusCode, [String? message])
      : super(message ?? 'Server error (code $statusCode). Please try again later.');
}

/// Thrown when the response body cannot be parsed as expected.
class ParsingException extends ApiException {
  ParsingException([
    String message = 'Something went wrong while reading the server response.',
  ]) : super(message);
}

/// Catch-all for anything unforeseen.
class UnknownApiException extends ApiException {
  UnknownApiException([String message = 'An unexpected error occurred.'])
      : super(message);
}
