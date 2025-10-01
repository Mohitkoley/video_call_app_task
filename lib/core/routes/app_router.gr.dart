// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;
import 'package:video_calling/features/auth/presentation/screen/login_screen.dart'
    as _i1;
import 'package:video_calling/features/auth/presentation/screen/sign_up_screen.dart'
    as _i2;
import 'package:video_calling/features/auth/presentation/screen/user_list_screen.dart'
    as _i4;
import 'package:video_calling/features/splash_screen.dart' as _i3;

/// generated route for
/// [_i1.LoginScreen]
class LoginRoute extends _i5.PageRouteInfo<void> {
  const LoginRoute({List<_i5.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i1.LoginScreen();
    },
  );
}

/// generated route for
/// [_i2.SignUpScreen]
class SignUpRoute extends _i5.PageRouteInfo<void> {
  const SignUpRoute({List<_i5.PageRouteInfo>? children})
    : super(SignUpRoute.name, initialChildren: children);

  static const String name = 'SignUpRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i2.SignUpScreen();
    },
  );
}

/// generated route for
/// [_i3.SplashScreen]
class SplashRoute extends _i5.PageRouteInfo<void> {
  const SplashRoute({List<_i5.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i3.SplashScreen();
    },
  );
}

/// generated route for
/// [_i4.UsersListScreen]
class UsersListRoute extends _i5.PageRouteInfo<UsersListRouteArgs> {
  UsersListRoute({
    _i6.Key? key,
    required String currentUserId,
    List<_i5.PageRouteInfo>? children,
  }) : super(
         UsersListRoute.name,
         args: UsersListRouteArgs(key: key, currentUserId: currentUserId),
         initialChildren: children,
       );

  static const String name = 'UsersListRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UsersListRouteArgs>();
      return _i4.UsersListScreen(
        key: args.key,
        currentUserId: args.currentUserId,
      );
    },
  );
}

class UsersListRouteArgs {
  const UsersListRouteArgs({this.key, required this.currentUserId});

  final _i6.Key? key;

  final String currentUserId;

  @override
  String toString() {
    return 'UsersListRouteArgs{key: $key, currentUserId: $currentUserId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UsersListRouteArgs) return false;
    return key == other.key && currentUserId == other.currentUserId;
  }

  @override
  int get hashCode => key.hashCode ^ currentUserId.hashCode;
}
