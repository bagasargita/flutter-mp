import 'package:dio/dio.dart';
import 'package:merah_putih/core/api/api_client.dart';
import 'package:merah_putih/core/error/failures.dart';
import 'package:merah_putih/core/utils/either.dart';
import 'package:merah_putih/features/auth/domain/entities/user.dart';
import 'package:merah_putih/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, User>> getProfile() async {
    try {
      final response = await _apiClient.getProfile();
      final userData = response.data!['user'] as Map<String, dynamic>;
      final user = User.fromJson(userData);
      return Right(user);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.message ?? 'Failed to get profile',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(NetworkFailure(message: 'Network error occurred'));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile(
    Map<String, dynamic> profileData,
  ) async {
    try {
      final response = await _apiClient.updateProfile(profileData: profileData);
      final userData = response.data!['user'] as Map<String, dynamic>;
      final user = User.fromJson(userData);
      return Right(user);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.message ?? 'Failed to update profile',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(NetworkFailure(message: 'Network error occurred'));
    }
  }
}
