import 'package:smart_mob/core/error/failures.dart';
import 'package:smart_mob/core/utils/either.dart';
import 'package:smart_mob/features/auth/domain/entities/user.dart';

abstract class ProfileRepository {
  Future<Either<Failure, User>> getProfile();
  Future<Either<Failure, User>> updateProfile(Map<String, dynamic> profileData);
}
