import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:video_calling/core/usecase/failure.dart';
import 'package:video_calling/features/auth/domain/entities/user.dart';
import 'package:video_calling/features/auth/domain/usecases/get_current_user.dart';
import 'package:video_calling/features/auth/domain/usecases/sign_in.dart';
import 'package:video_calling/features/auth/domain/usecases/sign_out.dart';
import 'package:video_calling/features/auth/domain/usecases/sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn signInUseCase;
  final SignUp signUpUseCase;
  final SignOut signOutUseCase;
  final GetCurrentUser getCurrentUserUseCase;

  AuthBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial()) {
    on<AuthSignInEvent>(_onSignIn);
    on<AuthSignUp>(_onSignUp);
    on<AuthSignOutEvent>(_onSignOut);
    on<AuthCheckStatus>(_onCheckStatus);
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

  Future<void> _onSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
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
      ifLeft: (String value) {
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
}
