import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
    // 初始空白主路由，加入 AuthGuard 驗證來決定後面的路由
    AutoRoute(
      path: '/home',
      page: HomeRoute.page,
    ),
    AutoRoute(
      path: '/login',
      initial: true,
      page: LoginRoute.page,
    ),
  ];
}
