import 'package:dart_either/dart_either.dart';
import 'package:video_calling/core/usecase/failure.dart';
import 'package:video_calling/features/auth/domain/entities/user.dart';
import 'package:video_calling/features/auth/domain/repository/auth_repository.dart';

class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<Either<Failure, UserEntity>> call(
    String email,
    String password,
    String displayName,
  ) {
    return repository.signUp(email, password, displayName);
  }
}
