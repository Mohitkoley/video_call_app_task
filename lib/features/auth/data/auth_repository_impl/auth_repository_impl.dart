// lib/data/auth/repositories/auth_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_either/dart_either.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_calling/core/usecase/failure.dart';

import 'package:video_calling/features/auth/domain/entities/user.dart';
import 'package:video_calling/features/auth/domain/repository/auth_repository.dart';

import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(this._auth, this._firestore);

  @override
  Future<Either<Failure, UserEntity>> signUp(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = cred.user!.uid;
      final defaultChannel = 'user_$uid';

      final user = UserModel(
        uid: uid,
        email: email,
        displayName: displayName,
        defaultChannel: defaultChannel,
        isOnline: true,
      );

      await _firestore.collection('users').doc(uid).set({
        ...user.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
        'lastSeen': FieldValue.serverTimestamp(),
      });

      await _firestore.collection('channels').doc(defaultChannel).set({
        'owner': uid,
        'channelName': defaultChannel,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signIn(
    String email,
    String password,
  ) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = cred.user!.uid;

      final snapshot = await _firestore.collection('users').doc(uid).get();
      if (!snapshot.exists) {
        return Left(AuthFailure("User not found in Firestore"));
      }

      final user = UserModel.fromFirebase(uid, snapshot.data() ?? {});
      await _firestore.collection('users').doc(uid).update({
        'isOnline': true,
        'lastSeen': FieldValue.serverTimestamp(),
      });

      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? "Auth error"));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final snapshot = await _firestore.collection('users').doc(user.uid).get();
    if (!snapshot.exists) return null;
    return UserModel.fromFirebase(user.uid, snapshot.data()!);
  }

  @override
  Future<void> signOut() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        await _firestore.collection('users').doc(uid).update({
          'isOnline': false,
          'lastSeen': FieldValue.serverTimestamp(),
        });
      }
      await _auth.signOut();
    } catch (e) {
      // Handle sign out error if necessary
      rethrow;
    }
  }
}
