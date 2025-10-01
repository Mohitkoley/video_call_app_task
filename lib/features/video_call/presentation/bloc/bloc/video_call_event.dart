part of 'video_call_bloc.dart';

sealed class VideoCallEvent extends Equatable {
  const VideoCallEvent();

  @override
  List<Object> get props => [];
}

class CallStarted extends VideoCallEvent {
  final String callerId;
  final String receiverId;

  const CallStarted({required this.callerId, required this.receiverId});

  @override
  List<Object> get props => [callerId, receiverId];
}

class CallEnded extends VideoCallEvent {
  final String channelName;
  const CallEnded(this.channelName);

  @override
  List<Object> get props => [channelName];
}
