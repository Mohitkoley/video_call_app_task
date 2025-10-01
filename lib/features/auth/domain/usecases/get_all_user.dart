// lib/features/user/domain/usecases/get_all_users.dart

import 'package:dart_either/dart_either.dart';
import 'package:injectable/injectable.dart';
import 'package:video_calling/core/usecase/failure.dart';
import 'package:video_calling/features/auth/domain/entities/user.dart';
import 'package:video_calling/features/auth/domain/repository/auth_repository.dart'
    show AuthRepository;

@lazySingleton
class GetAllUsers {
  final AuthRepository repository;
  GetAllUsers(this.repository);

  Stream<Either<Failure, List<UserEntity>>> call() {
    return repository.getAllUsers();
  }
}
