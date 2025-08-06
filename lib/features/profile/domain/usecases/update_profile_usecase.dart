import 'package:smart_mob/core/error/failures.dart';
import 'package:smart_mob/core/utils/either.dart';
import 'package:smart_mob/features/auth/domain/entities/user.dart';
import 'package:smart_mob/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<Either<Failure, User>> call(Map<String, dynamic> profileData) async {
    return await _repository.updateProfile(profileData);
  }
}
