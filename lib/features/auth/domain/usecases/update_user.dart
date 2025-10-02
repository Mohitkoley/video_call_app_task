import 'package:dart_either/dart_either.dart';
import 'package:injectable/injectable.dart';
import 'package:video_calling/core/usecase/failure.dart';
import 'package:video_calling/features/auth/domain/repository/auth_repository.dart';

@lazySingleton
class UpdateUser {
  final AuthRepository repository;
  UpdateUser(this.repository);

  Future<Either<Failure, void>> call(Map<String, dynamic> data) {
    return repository.updateUserStatus(data);
  }
}
