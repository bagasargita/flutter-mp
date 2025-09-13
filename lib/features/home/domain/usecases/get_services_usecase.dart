import 'package:merah_putih/core/error/failures.dart';
import 'package:merah_putih/core/utils/either.dart';
import 'package:merah_putih/features/home/domain/repositories/home_repository.dart';

class GetServicesUseCase {
  final HomeRepository _repository;

  GetServicesUseCase(this._repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> call() async {
    return await _repository.getServices();
  }
}
