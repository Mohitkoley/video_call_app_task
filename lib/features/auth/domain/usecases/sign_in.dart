import 'package:dart_either/dart_either.dart';
import 'package:video_calling/core/usecase/failure.dart';
import 'package:video_calling/features/auth/domain/entities/user.dart';
import 'package:video_calling/features/auth/domain/repository/auth_repository.dart';

class SignIn {
  final AuthRepository repository;
  SignIn(this.repository);

  Future<Either<Failure, UserEntity>> call(String email, String password) {
    return repository.signIn(email, password);
  }
}
