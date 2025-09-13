import 'package:merah_putih/core/error/failures.dart';
import 'package:merah_putih/core/utils/either.dart';
import 'package:merah_putih/features/auth/domain/entities/user.dart';
import 'package:merah_putih/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<Failure, User>> call({
    required String identifier,
    required String password,
  }) async {
    return await _repository.login(identifier: identifier, password: password);
  }
}
