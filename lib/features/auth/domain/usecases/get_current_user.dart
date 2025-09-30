import 'package:dart_either/dart_either.dart';
import 'package:video_calling/features/auth/domain/entities/user.dart';
import 'package:video_calling/features/auth/domain/repository/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  Future<Either<String, UserEntity?>> call() async {
    try {
      final user = await repository.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
