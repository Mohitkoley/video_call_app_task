import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:video_calling/core/usecase/failure.dart';
import 'package:video_calling/features/auth/domain/entities/user.dart';
import 'package:video_calling/features/auth/domain/usecases/get_all_user.dart';
import 'package:video_calling/features/auth/domain/usecases/get_current_user.dart';
import 'package:video_calling/features/auth/domain/usecases/sign_in.dart';
import 'package:video_calling/features/auth/domain/usecases/sign_out.dart';
import 'package:video_calling/features/auth/domain/usecases/sign_up.dart';
import 'package:injectable/injectable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn signInUseCase;
  final SignUp signUpUseCase;
  final SignOut signOutUseCase;
  final GetCurrentUser getCurrentUserUseCase;
  final GetAllUsers getAllUsersUseCase;

  AuthBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
    required this.getAllUsersUseCase,
  }) : super(AuthInitial()) {
    on<AuthSignInEvent>(_onSignIn);
    on<AuthSignUpEvent>(_onSignUp);
    on<AuthSignOutEvent>(_onSignOut);
    on<AuthCheckStatus>(_onCheckStatus);
    on<LoadUsers>(_onLoadUsers);
  }

  Future<void> _onSignIn(AuthSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signInUseCase(event.email, event.password);
    result.fold(
      ifLeft: (Failure value) {
        emit(AuthFailure(value.message));
      },
      ifRight: (UserEntity value) {
        emit(AuthAuthenticated(value));
      },
    );
  }

  Future<void> _onSignUp(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signUpUseCase(
      event.email,
      event.password,
      event.displayName,
    );
    result.fold(
      ifLeft: (Failure value) {
        emit(AuthFailure(value.message));
      },
      ifRight: (UserEntity value) {
        emit(AuthAuthenticated(value));
      },
    );
  }

  Future<void> _onSignOut(
    AuthSignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    await signOutUseCase();
    emit(AuthUnauthenticated());
  }

  Future<void> _onCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    final result = await getCurrentUserUseCase();
    result.fold(
      ifLeft: (value) {
        emit(AuthUnauthenticated());
      },
      ifRight: (UserEntity? value) {
        if (value != null) {
          emit(AuthAuthenticated(value));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  FutureOr<void> _onLoadUsers(LoadUsers event, Emitter<AuthState> emit) {
    emit(AuthLoading());
    final stream = getAllUsersUseCase();
    stream.listen((result) {
      result.fold(
        ifLeft: (Failure value) {
          emit(AuthFailure(value.message));
        },
        ifRight: (List<UserEntity> users) {
          emit(UsersLoaded(users));
        },
      );
    });
  }
}
