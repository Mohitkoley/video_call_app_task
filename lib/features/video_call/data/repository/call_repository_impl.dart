// lib/features/call/data/repositories/call_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_either/dart_either.dart';
import 'package:injectable/injectable.dart';
import 'package:video_calling/core/usecase/failure.dart';
import 'package:video_calling/features/video_call/domain/entities/call_enitty.dart';
import 'package:video_calling/features/video_call/domain/repository/call_repository.dart';

@LazySingleton(as: CallRepository)
class CallRepositoryImpl implements CallRepository {
  final FirebaseFirestore firestore;

  CallRepositoryImpl(this.firestore);

  @override
  Future<Either<Failure, void>> startCall(VideoCallEntity call) async {
    try {
      await firestore.collection('calls').doc(call.channelName).set({
        'callerId': call.callerId,
        'receiverId': call.receiverId,
        'channelName': call.channelName,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> endCall(String channelName) async {
    try {
      await firestore.collection('calls').doc(channelName).delete();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
