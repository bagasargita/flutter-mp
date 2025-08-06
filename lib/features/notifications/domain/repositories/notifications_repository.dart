import 'package:smart_mob/core/error/failures.dart';
import 'package:smart_mob/core/utils/either.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, List<Map<String, dynamic>>>> getNotifications();
}
