import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled1/core/service/google_signin_service.dart';
import 'package:untitled1/router/app_router.gr.dart';
import 'package:untitled1/viewmodel/base_view_model.dart';

class HomeViewModel extends BaseViewModel {
  void logout(BuildContext context) async{
    globalViewModel.setUser(null);
    await GoogleSigninService.logout();
    AutoRouter.of(context).replace(LoginRoute());
  }
}