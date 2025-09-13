import 'package:merah_putih/core/error/failures.dart';
import 'package:merah_putih/core/utils/either.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Map<String, dynamic>>>> getServices();
}
