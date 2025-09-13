import 'package:merah_putih/core/error/failures.dart';
import 'package:merah_putih/core/utils/either.dart';
import 'package:merah_putih/features/auth/domain/entities/user.dart';
import 'package:merah_putih/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  Future<Either<Failure, User>> call() async {
    return await _repository.getProfile();
  }
}
