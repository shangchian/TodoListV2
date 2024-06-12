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
          tasks.add(Task(id: key, title: value['title'], description: value['description'], category: value['category'], priority: value['priority'], progress: value['progress'], dueDay: value['dueDay']));
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
      print('Function: updateTotalTask(), Failed to retrieve data: $error');
    }
  }

  ValueNotifier<List<Task>> _showTasks = ValueNotifier(<Task>[]);
  ValueNotifier<List<Task>> get showTasks => _showTasks;
  void setShowTask(List<Task> showTasks) {
    this._showTasks.value = showTasks;
  }

  // 依照截止日期排序
  List<Task> sortTasksByDueDay(List<Task> tasks) {
    tasks.sort((a, b) {
      DateTime dateA = DateTime.parse(a.dueDay);
      DateTime dateB = DateTime.parse(b.dueDay);
      return dateA.compareTo(dateB);
    });
    return tasks;
  }

  // 依照優先權排序
  List<Task> sortTasksByPriority(List<Task> tasks) {
    tasks.sort((a, b) {
      int priorityA = int.parse(a.priority);
      int priorityB = int.parse(b.priority);
      return priorityB.compareTo(priorityA);
    });
    return tasks;
  }

  // 根據進度篩選
  List<Task> filterTasksByProgress(List<Task> tasks, String progress) {
    return tasks.where((task) => task.progress == progress).toList();
  }

  // 依照搜尋
  List<Task> filterTasksByQuery(List<Task> tasks, String query) {
    return tasks.where((task) =>
    task.title.contains(query) || task.description.contains(query)
    ).toList();
  }

  // Firebase 更新任務
  Future<void> updateTask(String taskId, String newTitle, String newDescription, String newCategory, String newPriority, String newProgress, String newDueDay) async {
    try {
      final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref('accounts');
      await _databaseReference.child(user!.id).child('tasks').child(taskId).update({
        'title': newTitle,
        'description': newDescription,
        'category': newCategory,
        'priority': newPriority,
        'progress': newProgress,
        'dueDay': newDueDay
      }).then((_) {
        print('成功更新任務');
        // 更新全局 Task
        updateTotalTask();
        setShowTask(totalTasks);
      }).catchError((error) {
        print('更新任務失敗: $error');
      });
    } catch (error) {
      print('Failed to update data: $error');
    }
  }

}