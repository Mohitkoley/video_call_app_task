import 'package:dart_either/dart_either.dart';
import 'package:video_calling/core/usecase/failure.dart';

import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signUp(
    String email,
    String password,
    String displayName,
  );
  Future<Either<Failure, UserEntity>> signIn(String email, String password);
  Future<UserEntity?> getCurrentUser();
  Stream<Either<Failure, List<UserEntity>>> getAllUsers();
  Future<void> signOut();
}
