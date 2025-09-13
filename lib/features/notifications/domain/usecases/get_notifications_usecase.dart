import 'package:merah_putih/core/error/failures.dart';
import 'package:merah_putih/core/utils/either.dart';
import 'package:merah_putih/features/notifications/domain/repositories/notifications_repository.dart';

class GetNotificationsUseCase {
  final NotificationsRepository _repository;

  GetNotificationsUseCase(this._repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> call() async {
    return await _repository.getNotifications();
  }
}
