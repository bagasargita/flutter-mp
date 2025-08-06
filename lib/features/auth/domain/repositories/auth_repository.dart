import 'package:smart_mob/core/error/failures.dart';
import 'package:smart_mob/core/utils/either.dart';
import 'package:smart_mob/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User?>> getCurrentUser();

  Future<Either<Failure, void>> saveUser(User user);

  Future<Either<Failure, void>> clearUser();
}
