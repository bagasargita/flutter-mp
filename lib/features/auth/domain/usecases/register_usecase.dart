import 'package:merah_putih/core/error/failures.dart';
import 'package:merah_putih/core/utils/either.dart';
import 'package:merah_putih/features/auth/domain/entities/user.dart';
import 'package:merah_putih/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    return await _repository.register(
      email: email,
      password: password,
      name: name,
      phoneNumber: phoneNumber,
    );
  }
}
