import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_calling/core/routes/app_router.gr.dart';
import 'package:video_calling/features/auth/presentation/bloc/bloc/auth_bloc.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authBloc = context.read<AuthBloc>();
      authBloc.add(AuthCheckStatus());

      Future.delayed(Duration(seconds: 2), () {
        if (authBloc.state is AuthAuthenticated) {
          context.router.replace(
            UsersListRoute(
              currentUserId: (authBloc.state as AuthAuthenticated).user.uid,
            ),
          );
        } else {
          context.router.replace(LoginRoute());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/image/video.png', width: 200, height: 200),
      ),
    );
  }
}
