// lib/application/auth/auth_event.dart
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthSignUp extends AuthEvent {
  final String email;
  final String password;
  final String displayName;

  const AuthSignUp({
    required this.email,
    required this.password,
    required this.displayName,
  });

  @override
  List<Object?> get props => [email, password, displayName];
}

class AuthSignInEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthSignOutEvent extends AuthEvent {
  const AuthSignOutEvent();
}

class AuthCheckStatus extends AuthEvent {
  const AuthCheckStatus();
}
