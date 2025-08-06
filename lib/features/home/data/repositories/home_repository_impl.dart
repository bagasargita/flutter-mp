import 'package:dio/dio.dart';
import 'package:smart_mob/core/api/api_client.dart';
import 'package:smart_mob/core/error/failures.dart';
import 'package:smart_mob/core/utils/either.dart';
import 'package:smart_mob/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ApiClient _apiClient;

  HomeRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getServices() async {
    try {
      final response = await _apiClient.getServices();
      return Right(response.data!.cast<Map<String, dynamic>>());
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.message ?? 'Failed to get services',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(NetworkFailure(message: 'Network error occurred'));
    }
  }
}
