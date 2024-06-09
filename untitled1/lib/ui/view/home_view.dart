import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/ui/view/base_view.dart';
import 'package:untitled1/viewmodel/home_view_model.dart';

import '../../generated/l10n.dart';

@RoutePage()
class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                model.globalViewModel.user!.photoUrl == "" ? Image.asset('assets/image/user_icon.png', width: 30, height: 30,) : Image.network(model.globalViewModel.user!.photoUrl, width: 30, height: 30),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(model.globalViewModel.user!.name),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  model.logout(context);
                },
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          body: Container(
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.all(30),
            child: FloatingActionButton.extended(
              onPressed: () {},
              label: Text('Add'),
              icon: Icon(Icons.add),
            ),
          ),
        );
      },
      modelProvider: () => HomeViewModel(),
    );
  }
}
