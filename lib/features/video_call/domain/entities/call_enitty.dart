// lib/features/call/domain/entities/call_entity.dart
class VideoCallEntity {
  final String channelName;
  final String callerId;
  final String receiverId;

  VideoCallEntity({
    required this.channelName,
    required this.callerId,
    required this.receiverId,
  });
}
