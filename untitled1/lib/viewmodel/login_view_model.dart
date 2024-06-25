
import 'package:auto_route/auto_route.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled1/core/model/user.dart';
import 'package:untitled1/core/service/google_signin_service.dart';
import 'package:untitled1/router/app_router.gr.dart';
import 'package:untitled1/viewmodel/base_view_model.dart';


class LoginViewModel extends BaseViewModel {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref('accounts');
  Future signIn(BuildContext context) async {
    GoogleSignInAccount? user = await GoogleSigninService.login();
    if (user != null) {
      print('login successfully');
      globalViewModel.setUser(
          User(
              id: user.id,
              email: user.email,
              name: user.displayName == null ? "": user.displayName!,
              photoUrl: user.photoUrl == null ? "": user.photoUrl!
          )
      );
      _writeData();
      _listenToData();
      print(user.email);
      AutoRouter.of(context).replace(HomeRoute());
    }
    else {
      print('null');
    }
  }

  void _writeData() async{
    try {
      DataSnapshot snapshot = await _databaseReference.get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> users = snapshot.value as Map<dynamic, dynamic>;
        bool userExist = false;
        users.forEach((key, value) {
          if (key == globalViewModel.user!.id) {
            userExist = true;
          }
        });
        if (!userExist) {
          _databaseReference.child(globalViewModel.user!.id).set({
            'email': globalViewModel.user!.email,
            'photoUrl': globalViewModel.user!.photoUrl,
            'name': globalViewModel.user!.name,
            'time': DateTime.now().toString()
          }).then((_) {
            print('Data written successfully');
          }).catchError((error) {
            print('Failed to write data: $error');
          });
        }
      } else {
        _databaseReference.child(globalViewModel.user!.id).set({
          'email': globalViewModel.user!.email,
          'photoUrl': globalViewModel.user!.photoUrl,
          'name': globalViewModel.user!.name,
          'time': DateTime.now().toString()
        }).then((_) {
          print('Data written successfully');
        }).catchError((error) {
          print('Failed to write data: $error');
        });
        print('No data available.');
      }
    } catch (error) {
      print('Function: _writeData, Failed to retrieve data: $error');
    }
  }

  void _listenToData() async{
    // _databaseReference.child(globalViewModel.user!.id).onValue.listen((event) {
    //   final data = event.snapshot.value;
    //   print('Data updated: $data');
    // });

    globalViewModel.updateTotalTask();
  }

}