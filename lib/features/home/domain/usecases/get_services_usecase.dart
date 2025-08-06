import 'package:smart_mob/core/error/failures.dart';
import 'package:smart_mob/core/utils/either.dart';
import 'package:smart_mob/features/home/domain/repositories/home_repository.dart';

class GetServicesUseCase {
  final HomeRepository _repository;

  GetServicesUseCase(this._repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> call() async {
    return await _repository.getServices();
  }
}
