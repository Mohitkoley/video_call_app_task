// lib/features/call/application/call_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:video_calling/features/video_call/domain/entities/call_enitty.dart';
import 'package:video_calling/features/video_call/domain/usecase/end_call.dart';
import 'package:video_calling/features/video_call/domain/usecase/start_call.dart';

part 'video_call_event.dart';
part 'video_call_state.dart';

@lazySingleton
class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  final StartCall startCall;
  final EndCall endCall;

  VideoCallBloc(this.startCall, this.endCall) : super(VideoCallInitial()) {
    on<CallStarted>((event, emit) async {
      final channelName = "call_${event.callerId}_${event.receiverId}";
      final callEntity = VideoCallEntity(
        channelName: channelName,
        callerId: event.callerId,
        receiverId: event.receiverId,
      );

      final result = await startCall(callEntity);
      result.fold(
        ifLeft: (failure) => emit(CallError(failure.message)),
        ifRight: (_) => emit(CallInProgress(channelName)),
      );
    });

    on<CallEnded>((event, emit) async {
      final result = await endCall(event.channelName);
      result.fold(
        ifLeft: (failure) => emit(CallError(failure.message)),
        ifRight: (_) => emit(CallEndedState()),
      );
    });
  }
}
