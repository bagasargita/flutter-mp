import 'package:merah_putih/core/error/failures.dart';
import 'package:merah_putih/core/utils/either.dart';
import 'package:merah_putih/features/auth/domain/entities/user.dart';
import 'package:merah_putih/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<Either<Failure, User>> call(Map<String, dynamic> profileData) async {
    return await _repository.updateProfile(profileData);
  }
}
