class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  NetworkException(this.message, {this.statusCode});
  @override
  String toString() => 'NetworkException($statusCode): $message';
}

class BadRequestException extends NetworkException {
  BadRequestException(super.message) : super(statusCode: 400);
}

class UnauthorizedException extends NetworkException {
  UnauthorizedException(super.message) : super(statusCode: 401);
}

class ForbiddenException extends NetworkException {
  ForbiddenException(super.message) : super(statusCode: 403);
}

class NotFoundException extends NetworkException {
  NotFoundException(super.message) : super(statusCode: 404);
}

class TimeoutException extends NetworkException {
  TimeoutException(super.message);
}

class ServerException extends NetworkException {
  ServerException(super.message, {super.statusCode});
}

class NoConnectionException extends NetworkException {
  NoConnectionException(super.message);
}

class UnknownNetworkException extends NetworkException {
  UnknownNetworkException(super.message, {super.statusCode});
}
