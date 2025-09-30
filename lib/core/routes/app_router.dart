import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
@singleton
class AppRouter extends RootStackRouter {
  @override
  // TODO: implement routes
  List<AutoRoute> get routes => [];
}
