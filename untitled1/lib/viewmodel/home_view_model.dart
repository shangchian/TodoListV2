import 'package:auto_route/auto_route.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/service/google_signin_service.dart';
import 'package:untitled1/router/app_router.gr.dart';
import 'package:untitled1/viewmodel/base_view_model.dart';

import '../core/model/task.dart';
import '../generated/l10n.dart';

class HomeViewModel extends BaseViewModel {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref('accounts');
  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController = TextEditingController();

  void logout(BuildContext context) async{
    globalViewModel.setUser(null);
    globalViewModel.setShowTask(<Task>[]);
    globalViewModel.setTotalTask(<Task>[]);
    await GoogleSigninService.logout();
    AutoRouter.of(context).replace(LoginRoute());
  }

  void addTask(BuildContext context) {
    titleTextEditingController = TextEditingController();
    descriptionTextEditingController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(S.current.addTask),

            content: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 標題
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Material(
                          child: TextField(
                            // 綁定 viewmodel 的 controller
                            controller: titleTextEditingController,
                            // 輸入文字的樣式
                            style: const TextStyle(fontSize: null, fontWeight: null, color: null),
                            decoration: InputDecoration(
                              // 輸入框周圍的文字、樣式
                              labelText: S.current.title, labelStyle: TextStyle(fontSize: null, fontWeight: null, color: null),

                              // 預設邊框樣式
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15), // 邊框圓滑程度
                              ),

                              // 焦點時的邊框樣式
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black45, // 邊框顏色
                                      width: 1 // 邊框粗細
                                  )
                              ),
                              // 啟用但未焦點時的邊框樣式
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black12, // 邊框顏色
                                      width: 1 // 邊框粗細
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // 描述
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Material(
                          child: TextField(
                            // 綁定 viewmodel 的 controller
                            controller: descriptionTextEditingController,
                            // 輸入文字的樣式
                            style: const TextStyle(fontSize: null, fontWeight: null, color: null),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              // 輸入框周圍的文字、樣式
                              labelText: S.current.description, labelStyle: TextStyle(fontSize: null, fontWeight: null, color: null),

                              // 預設邊框樣式
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15), // 邊框圓滑程度
                              ),

                              // 焦點時的邊框樣式
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black45, // 邊框顏色
                                      width: 1 // 邊框粗細
                                  )
                              ),
                              // 啟用但未焦點時的邊框樣式
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black12, // 邊框顏色
                                      width: 1 // 邊框粗細
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // 優先權
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  AutoRouter.of(context).pop();
                },
                child: Text(S.current.cancel),
              ),
              TextButton(
                onPressed: () {
                  _writeData();


                  // print('Entered text: ${_textFieldController.text}');
                  // print('Selected date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}');
                  AutoRouter.of(context).pop();
                },
                child: Text(S.current.finish),
              ),
            ],
          );
        },
    );
  }

  void _writeData() async{
    try {
      print("----------------" + DateTime.now().microsecondsSinceEpoch.toString());
      _databaseReference.child(globalViewModel.user!.id).child('tasks').child(DateTime.now().microsecondsSinceEpoch.toString()).set({
        'title': titleTextEditingController.text,
        'description': descriptionTextEditingController.text
      }).then((_) {
        print('Data written successfully'); 
      }).catchError((error) {
        print('Failed to write data: $error');
      });
    } catch (error) {
      print('Failed to retrieve data: $error');
    }

    _listenToData();
  }

  void _listenToData() {
    _databaseReference.child(globalViewModel.user!.id).child('tasks').onValue.listen((event) {
      final data = event.snapshot.value;
      print('Data updated: $data');
    });
  }

  void deleteTask(BuildContext context, String id) async{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.current.deleteTaskDialogTitle),
          content: Text(S.current.deleteTaskDialogDescription),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                AutoRouter.of(context).pop();
              },
              child: Text(S.current.no),
            ),
            TextButton(
              onPressed: () {

                _deleteData(id);

                AutoRouter.of(context).pop();
              },
              child: Text(S.current.yes),
            ),
          ],
        );
      },
    );
    // try {
    //   _databaseReference.child(globalViewModel.user!.id).child('tasks').child(id).remove().then((_) {
    //     print('Successfully deleted $id');
    //   }).catchError((error) {
    //     print('Failed to delete $id: $error');
    //   });
    // } catch (error) {
    //   print('Failed to retrieve data: $error');
    // }
  }

  void _deleteData(String id) {
    try {
      _databaseReference.child(globalViewModel.user!.id).child('tasks').child(id).remove().then((_) {
        print('Successfully deleted $id');
        globalViewModel.updateTotalTask();
        globalViewModel.setShowTask(globalViewModel.totalTasks);
      }).catchError((error) {
        print('Failed to delete $id: $error');
      });
    } catch (error) {
      print('Failed to retrieve data: $error');
    }
  }
}