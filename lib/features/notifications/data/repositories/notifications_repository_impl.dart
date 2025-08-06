import 'package:dio/dio.dart';
import 'package:smart_mob/core/api/api_client.dart';
import 'package:smart_mob/core/error/failures.dart';
import 'package:smart_mob/core/utils/either.dart';
import 'package:smart_mob/features/notifications/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final ApiClient _apiClient;

  NotificationsRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getNotifications() async {
    try {
      final response = await _apiClient.getNotifications();
      return Right(response.data!.cast<Map<String, dynamic>>());
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.message ?? 'Failed to get notifications',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(NetworkFailure(message: 'Network error occurred'));
    }
  }
}
