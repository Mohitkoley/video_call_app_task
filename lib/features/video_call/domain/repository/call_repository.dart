import 'package:dart_either/dart_either.dart';
import 'package:video_calling/core/usecase/failure.dart';
import 'package:video_calling/features/video_call/domain/entities/call_enitty.dart';

abstract class CallRepository {
  Future<Either<Failure, void>> startCall(VideoCallEntity call);
  Future<Either<Failure, void>> endCall(String channelName);
}
