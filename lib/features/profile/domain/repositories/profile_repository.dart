import 'package:merah_putih/core/error/failures.dart';
import 'package:merah_putih/core/utils/either.dart';
import 'package:merah_putih/features/auth/domain/entities/user.dart';

abstract class ProfileRepository {
  Future<Either<Failure, User>> getProfile();
  Future<Either<Failure, User>> updateProfile(Map<String, dynamic> profileData);
}
