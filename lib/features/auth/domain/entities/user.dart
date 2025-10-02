class UserEntity {
  final String uid;
  final String email;
  final String displayName;
  final String? defaultChannel;
  final bool isHost;

  UserEntity({
    required this.uid,
    required this.email,
    required this.displayName,
    this.defaultChannel,
    required this.isHost,
  });
}
