import 'package:dart_either/dart_either.dart';
import 'package:injectable/injectable.dart';
import 'package:video_calling/core/usecase/failure.dart';
import 'package:video_calling/features/video_call/domain/entities/call_enitty.dart';
import 'package:video_calling/features/video_call/domain/repository/call_repository.dart';

@lazySingleton
class StartCall {
  final CallRepository repository;
  StartCall(this.repository);

  Future<Either<Failure, void>> call(VideoCallEntity call) {
    return repository.startCall(call);
  }
}
