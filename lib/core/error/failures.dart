abstract class Failure {
  const Failure();

  String get message;
}

class ServerFailure extends Failure {
  @override
  final String message;
  final int? statusCode;

  const ServerFailure({required this.message, this.statusCode});
}

class NetworkFailure extends Failure {
  @override
  final String message;

  const NetworkFailure({required this.message});
}

class CacheFailure extends Failure {
  @override
  final String message;

  const CacheFailure({required this.message});
}

class InvalidInputFailure extends Failure {
  @override
  final String message;

  const InvalidInputFailure({required this.message});
}

class UnauthorizedFailure extends Failure {
  @override
  final String message;

  const UnauthorizedFailure({required this.message});
}

class NotFoundFailure extends Failure {
  @override
  final String message;

  const NotFoundFailure({required this.message});
}
