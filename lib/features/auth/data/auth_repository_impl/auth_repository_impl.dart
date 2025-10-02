// lib/data/auth/repositories/auth_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_either/dart_either.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:video_calling/core/usecase/failure.dart';

import 'package:video_calling/features/auth/domain/entities/user.dart';
import 'package:video_calling/features/auth/domain/repository/auth_repository.dart';

import '../models/user_model.dart';

@LazySingleton(as: AuthRepository)
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
        // defaultChannel: defaultChannel,
        isHost: false,
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return Left(ServerFailure('Email is already registered.'));
      }
      return Left(ServerFailure(e.message ?? 'Unknown error'));
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
  Stream<Either<Failure, List<UserEntity>>> getAllUsers() async* {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        yield Left(AuthFailure("No authenticated user"));
        return;
      }

      yield* _firestore
          .collection('users')
          .snapshots()
          .map<Either<Failure, List<UserEntity>>>((snapshot) {
            final users = snapshot.docs
                .where((doc) => doc.id != currentUser.uid)
                .map(
                  (doc) =>
                      UserModel.fromFirebase(doc.id, doc.data()) as UserEntity,
                )
                .toList();
            return Right<Failure, List<UserEntity>>(users);
          })
          .handleError((error) {
            return Left(ServerFailure(error.toString()));
          });
    } catch (e) {
      yield Left(ServerFailure(e.toString()));
    }
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

  @override
  Future<Either<Failure, void>> updateUserStatus(Map<String, dynamic> data) {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        //remove isHost and defaultChannel from all other users if isHost is true
        if (data.containsKey('isHost') && data['isHost'] == true) {
          _firestore
              .collection('users')
              .where('isHost', isEqualTo: true)
              .get()
              .then((snapshot) {
                for (var doc in snapshot.docs) {
                  if (doc.id != uid) {
                    doc.reference.update({'isHost': false});
                    doc.reference.update({'defaultChannel': null});
                  }
                }
              });
        }

        return _firestore
            .collection('users')
            .doc(uid)
            .update(data)
            .then((_) => Right<Failure, void>(null))
            .catchError((error) => Left(ServerFailure(error.toString())));
      } else {
        return Future.value(Left(AuthFailure("No authenticated user")));
      }
    } catch (e) {
      return Future.value(Left(ServerFailure(e.toString())));
    }
  }
}
