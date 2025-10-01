import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:injectable/injectable.dart';
import 'package:video_calling/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password);
  Future<UserModel?> getCurrentUser();
  Future<void> signOut();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase.FirebaseAuth auth;

  AuthRemoteDataSourceImpl(this.auth);

  @override
  Future<void> signOut() async => await auth.signOut();

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = auth.currentUser;
    if (user != null) {
      return UserModel(
        uid: user.uid,
        email: user.email!,
        displayName: user.displayName ?? '',
        defaultChannel: 'user_${user.uid}',
        isOnline: true,
      );
    } else {
      return null;
    }
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    final cred = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user!;
    return UserModel(
      uid: user.uid,
      email: user.email!,
      displayName: user.displayName ?? '',
      defaultChannel: 'user_${user.uid}',
      isOnline: true,
    );
  }

  @override
  Future<UserModel> signUp(String email, String password) async {
    final cred = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user!;
    return UserModel(
      uid: user.uid,
      email: user.email!,
      displayName: user.displayName ?? '',
      defaultChannel: 'user_${user.uid}',
      isOnline: true,
    );
  }
}
