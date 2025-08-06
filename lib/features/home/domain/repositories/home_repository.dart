import 'package:smart_mob/core/error/failures.dart';
import 'package:smart_mob/core/utils/either.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Map<String, dynamic>>>> getServices();
}
