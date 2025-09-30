import 'package:dart_either/dart_either.dart';

import 'package:video_calling/core/usecase/failure.dart';

abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams {}
