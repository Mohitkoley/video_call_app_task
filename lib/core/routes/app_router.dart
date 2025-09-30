import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:video_calling/core/routes/route_names.dart';
import 'package:video_calling/features/auth/presentation/screen/login_screen.dart';

import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
@singleton
class AppRouter extends RootStackRouter {
  @override
  // TODO: implement routes
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, path: RouteNames.login, initial: true),
    AutoRoute(page: SignUpRoute.page, path: RouteNames.signup),
  ];
}
