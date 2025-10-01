part of 'video_call_bloc.dart';

sealed class VideoCallState extends Equatable {
  const VideoCallState();

  @override
  List<Object> get props => [];
}

final class VideoCallInitial extends VideoCallState {}

class CallInProgress extends VideoCallState {
  final String channelName;
  const CallInProgress(this.channelName);
}

class CallEndedState extends VideoCallState {}

class CallError extends VideoCallState {
  final String message;
  const CallError(this.message);
}
