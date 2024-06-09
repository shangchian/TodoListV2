import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../core/model/task.dart';
import '../core/model/user.dart';

class GlobalViewModel extends ChangeNotifier {
  // user
  User? _user = null;
  User? get user => _user;
  void setUser(User? user) {
    this._user = user;
  }

  List<Task> _totalTasks = <Task>[];
  List<Task> get totalTasks => _totalTasks;
  void setTotalTask(List<Task> totalTasks) {
    this._totalTasks = totalTasks;
  }

  void updateTotalTask() async{
    final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref('accounts');
    try {
      List<Task> tasks = <Task>[];
      DataSnapshot snapshot = await _databaseReference.child(user!.id).child('tasks').get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> users = snapshot.value as Map<dynamic, dynamic>;
        users.forEach((key, value) {
          tasks.add(Task(title: value['title'], description: value['description']));
        });
        setTotalTask(tasks);
        setShowTask(tasks);
        print('===================');
        for (var i = 0 ; i < totalTasks.length ; i ++) {
          print(totalTasks[i].title);
          print(totalTasks[i].description);
        }
        print('===================');
      }
    } catch (error) {
      print('Failed to retrieve data: $error');
    }
  }

  ValueNotifier<List<Task>> _showTasks = ValueNotifier(<Task>[]);
  ValueNotifier<List<Task>> get showTasks => _showTasks;
  void setShowTask(List<Task> showTasks) {
    this._showTasks.value = showTasks;
  }
}