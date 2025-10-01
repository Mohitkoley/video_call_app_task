import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:video_calling/core/service_locator/di.dart';
import 'package:video_calling/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:video_calling/firebase_options.dart';
import 'package:video_calling/my_app.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    configureDependencies();
    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (context) => getIt<AuthBloc>()),
        ],
        child: MyApp(),
      ),
    );
  }, catchUnhandledExceptions);
}

void catchUnhandledExceptions(Object error, StackTrace? stack) {
  FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  debugPrintStack(stackTrace: stack, label: error.toString());
}
