import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/ui/view/base_view.dart';
import 'package:untitled1/viewmodel/login_view_model.dart';

import '../../generated/l10n.dart';

@RoutePage()
class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView(
        builder: (context, model, child) {
          return Container(
            color: Colors.white,
            child: Center(
              child: Container(
                margin: EdgeInsets.all(10),
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    model.signIn(context);
                  },
                  label: Text(S.current.google_login),
                  icon: Image.asset('assets/image/google_icon.png', width: 50, height: 50,),
                ),
              ),
            )
          );
        },
        modelProvider: () => LoginViewModel(),
    );
  }
}