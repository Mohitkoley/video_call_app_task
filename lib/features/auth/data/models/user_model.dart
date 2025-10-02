// lib/data/auth/models/user_model.dart

import 'package:video_calling/features/auth/domain/entities/user.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    required super.email,
    required super.displayName,
    super.defaultChannel,
    required super.isOnline,
  });

  factory UserModel.fromFirebase(String uid, Map<String, dynamic> json) {
    return UserModel(
      uid: uid,
      email: json['email'] ?? '',
      displayName: json['displayName'] ?? '',
      defaultChannel: json['defaultChannel'],
      isOnline: json['isOnline'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'displayName': displayName,
      'defaultChannel': defaultChannel,
      'isOnline': isOnline,
    };
  }
}
