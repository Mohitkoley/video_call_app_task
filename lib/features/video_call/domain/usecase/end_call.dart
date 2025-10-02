import 'package:dart_either/dart_either.dart';
import 'package:injectable/injectable.dart';
import 'package:video_calling/core/usecase/failure.dart';
import 'package:video_calling/features/video_call/domain/repository/call_repository.dart';

@singleton
class EndCall {
  final CallRepository repository;
  EndCall(this.repository);

  Future<Either<Failure, void>> call(String channelName) {
    return repository.endCall(channelName);
  }
}
