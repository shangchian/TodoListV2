import 'package:get_it/get_it.dart';
import 'package:untitled1/router/app_router.dart';
import 'package:untitled1/viewmodel/global_view_model.dart';
import 'package:untitled1/viewmodel/home_view_model.dart';
import 'package:untitled1/viewmodel/login_view_model.dart';

import 'core/service/google_signin_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => HomeViewModel());
  locator.registerLazySingleton(() => GlobalViewModel());
  locator.registerLazySingleton(() => LoginViewModel());
  locator.registerLazySingleton(() => GoogleSigninService());
  locator.registerSingleton<AppRouter>(AppRouter());
}
