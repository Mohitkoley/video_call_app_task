class UserEntity {
  final String uid;
  final String email;
  final String displayName;
  final String defaultChannel;
  final bool isOnline;

  UserEntity({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.defaultChannel,
    required this.isOnline,
  });
}
