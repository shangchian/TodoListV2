import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/core/service/google_signin_service.dart';
import 'package:untitled1/router/app_router.gr.dart';
import 'package:untitled1/viewmodel/base_view_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../core/model/task.dart';
import '../generated/l10n.dart';
import '../main.dart';

class HomeViewModel extends BaseViewModel {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref('accounts');
  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController searchTextEditingController = TextEditingController();
  ValueNotifier<int> categorySelected = ValueNotifier(0);
  ValueNotifier<int> prioritySelected = ValueNotifier(0);
  ValueNotifier<int> progressSelected = ValueNotifier(0);
  ValueNotifier<String> pickTime = ValueNotifier("");
  ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now());
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  ValueNotifier<String> selectedSortWay = ValueNotifier("0");
  ValueNotifier<bool> okButtonClickable = ValueNotifier(true);

  // 建立分類選項
  List<DropdownMenuItem> categoryItems = <DropdownMenuItem<int>>[
    DropdownMenuItem(child: Text(S.current.category_personal), value: 0,),
    DropdownMenuItem(child: Text(S.current.category_work), value: 1,),
  ];

  // 建立優先權選項
  List<DropdownMenuItem> priorityItems = <DropdownMenuItem<int>>[
    DropdownMenuItem(child: Text(S.current.priority_low), value: 0,),
    DropdownMenuItem(child: Text(S.current.priority_med), value: 1,),
    DropdownMenuItem(child: Text(S.current.priority_high), value: 2,),
  ];

  // 建立進度選項
  List<DropdownMenuItem> progressItems = <DropdownMenuItem<int>>[
    DropdownMenuItem(child: Text(S.current.progress_not_started), value: 0,),
    DropdownMenuItem(child: Text(S.current.progress_in_progress), value: 1,),
    DropdownMenuItem(child: Text(S.current.progress_completed), value: 2,),
  ];




  String getPriorityFromValue(String value) {
    if (value == "0") {
      return S.current.priority_low;
    }
    else if (value == "1") {
      return S.current.priority_med;
    }
    else {
      return S.current.priority_high;
    }
  }

  String getProgressFromValue(String value) {
    if (value == "0") {
      return S.current.progress_not_started;
    }
    else if (value == "1") {
      return S.current.progress_in_progress;
    }
    else {
      return S.current.progress_completed;
    }
  }

  // 登出
  void logout(BuildContext context) async{
    globalViewModel.setUser(null);
    globalViewModel.setShowTask(<Task>[]);
    globalViewModel.setTotalTask(<Task>[]);
    await GoogleSigninService.logout();
    AutoRouter.of(context).replace(LoginRoute());
  }

  // 排序任務
  void sortTask(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          selectedSortWay.value = "0";
          searchTextEditingController.text = "";
          return AlertDialog(
            title: Text(S.current.sort_task),
            content: Container(
              child: SingleChildScrollView(
                child: ValueListenableBuilder(
                  valueListenable: selectedSortWay,
                  builder: (context, value, child) {
                    progressSelected.value = 0;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 依照截止日期
                        ListTile(
                            title: Text(S.current.due_day),
                            leading: Radio<String>(
                              value: "0",
                              groupValue: selectedSortWay.value,
                              onChanged: (value) {
                                okButtonClickable.value = true;
                                selectedSortWay.value = value as String;
                              },
                            )
                        ),
                        // 依照優先權
                        ListTile(
                            title: Text(S.current.priority),
                            leading: Radio<String>(
                              value: "1",
                              groupValue: selectedSortWay.value,
                              onChanged: (value) {
                                okButtonClickable.value = true;
                                selectedSortWay.value = value as String;
                              },
                            )
                        ),
                        // 依照進度
                        ListTile(
                            title: Text(S.current.progress),
                            leading: Radio<String>(
                              value: "2",
                              groupValue: selectedSortWay.value,
                              onChanged: (value) {
                                okButtonClickable.value = true;
                                selectedSortWay.value = value as String;
                              },
                            ),
                            trailing: selectedSortWay.value == "2" ? Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                // 設置選單寬、高
                                // width: 200,
                                // height: 50,

                                child: ValueListenableBuilder(
                                  valueListenable: progressSelected,
                                  builder: (context, value, child) {
                                    return DropdownButton(
                                      value: progressSelected.value, // 設置當前選中的選項
                                      items: progressItems,  // 從 viewmodel 取得 item 資料
                                      // 當選項被選擇時觸發
                                      onChanged: (value) {
                                        progressSelected.value = value;
                                      },
                                    );
                                  },
                                )
                            ) : null,
                        ),
                        // 依照搜尋
                        ListTile(
                          title: Text(S.current.search),
                          leading: Radio<String>(
                            value: "3",
                            groupValue: selectedSortWay.value,
                            onChanged: (value) {
                              okButtonClickable.value = false;
                              selectedSortWay.value = value as String;
                            },
                          ),
                        ),
                        if(selectedSortWay.value == "3")...[
                          // Widget 的條件語法 if()...[] else..[]
                          Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: SizedBox(
                                width: 200,
                                child: Material(
                                  child:
                                  TextField(
                                    controller: searchTextEditingController,
                                    style: const TextStyle(fontSize: null, fontWeight: null, color: null),
                                    decoration: InputDecoration(
                                      labelText: S.current.search,
                                      labelStyle: TextStyle(fontSize: null, fontWeight: null, color: null),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black45, width: 1),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black12, width: 1),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      if (searchTextEditingController.text.trim() == "") {
                                        okButtonClickable.value = false;
                                      }
                                      else {
                                        okButtonClickable.value = true;
                                      }
                                    },
                                  ),
                                ),
                              ),
                          ),
                        ],
                      ],
                    );
                  },
                )
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  AutoRouter.of(context).pop();
                },
                child: Text(S.current.cancel),
              ),
              ValueListenableBuilder(
                  valueListenable: okButtonClickable,
                  builder: (context, value, child) {
                    return TextButton(
                      onPressed: okButtonClickable.value ? () {
                        // 依照截止日期
                        if (selectedSortWay.value == "0") {
                          setBusy(true);
                          globalViewModel.setShowTask(globalViewModel.sortTasksByDueDay(globalViewModel.totalTasks));
                          setBusy(false);
                        }
                        // 依照優先權
                        else if (selectedSortWay.value == "1") {
                          setBusy(true);
                          globalViewModel.setShowTask(globalViewModel.sortTasksByPriority(globalViewModel.totalTasks));
                          setBusy(false);
                        }
                        // 根據進度篩選
                        else if (selectedSortWay.value == "2") {
                          setBusy(true);
                          globalViewModel.setShowTask(globalViewModel.filterTasksByProgress(globalViewModel.totalTasks, progressSelected.value.toString()));
                          setBusy(false);
                        }
                        // 依照搜尋
                        else if (selectedSortWay.value == "3") {
                          setBusy(true);
                          globalViewModel.setShowTask(globalViewModel.filterTasksByQuery(globalViewModel.totalTasks, searchTextEditingController.text));
                          setBusy(false);
                        }
                        AutoRouter.of(context).pop();
                      } : null,
                      child: Text(S.current.ok),
                    );
                  },
              ),
            ],
          );
        },
    );
  }

  // 新增任務
  void addTask(BuildContext context) {
    titleTextEditingController = TextEditingController();
    descriptionTextEditingController = TextEditingController();
    prioritySelected = ValueNotifier(0);
    progressSelected = ValueNotifier(0);
    pickTime.value = formatter.format(DateTime.now());

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(S.current.add_task),
            content: Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    // 分類
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      // 設置選單寬、高
                      // width: 200,
                      // height: 50,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Container(
                                child: Text(S.current.category, style: TextStyle(fontSize: 20),),
                                margin: EdgeInsets.fromLTRB(10, 10, 15, 10),
                              )
                          ),
                          ValueListenableBuilder(
                            valueListenable: categorySelected,
                            builder: (context, value, child) {
                              return DropdownButton(
                                value: categorySelected.value, // 設置當前選中的選項
                                items: categoryItems,  // 從 viewmodel 取得 item 資料
                                // 當選項被選擇時觸發
                                onChanged: (value) {
                                  categorySelected.value = value;
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    // 優先權
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      // 設置選單寬、高
                      // width: 200,
                      // height: 50,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Container(
                                child: Text(S.current.priority, style: TextStyle(fontSize: 20),),
                                margin: EdgeInsets.fromLTRB(10, 10, 15, 10),
                              )
                          ),
                          ValueListenableBuilder(
                            valueListenable: prioritySelected,
                            builder: (context, value, child) {
                              return DropdownButton(
                                value: prioritySelected.value, // 設置當前選中的選項
                                items: priorityItems,  // 從 viewmodel 取得 item 資料
                                // 當選項被選擇時觸發
                                onChanged: (value) {
                                  prioritySelected.value = value;
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    // 進度
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      // 設置選單寬、高
                      // width: 200,
                      // height: 50,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              child: Text(S.current.progress, style: TextStyle(fontSize: 20),),
                              margin: EdgeInsets.fromLTRB(10, 10, 15, 10),
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: progressSelected,
                            builder: (context, value, child) {
                              return DropdownButton(
                                value: progressSelected.value, // 設置當前選中的選項
                                items: progressItems,  // 從 viewmodel 取得 item 資料
                                // 當選項被選擇時觸發
                                onChanged: (value) {
                                  progressSelected.value = value;
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    // 截止日期
                    Container(
                        margin: EdgeInsets.fromLTRB(10, 40, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(S.current.due_day, style: TextStyle(fontSize: 20),)
                            ),
                            Container(
                                child: IconButton(
                                  icon: Icon(Icons.calendar_month),
                                  onPressed: () {
                                    _showDatePicker(context);
                                  },
                                  iconSize: 25,
                                )
                            ),
                          ],
                        )
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ValueListenableBuilder(
                        valueListenable: pickTime,
                        builder: (context, value, child) {
                          return Text(pickTime.value);
                        },
                      )
                    )
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
                  if(isTitleTextEditEmpty(context)) {
                    _writeTaskToFirebase();
                    AutoRouter.of(context).pop();
                  }
                },
                child: Text(S.current.finish),
              ),
            ],
          );
        },
    );
  }

  // 檢查必填欄位
  bool isTitleTextEditEmpty(BuildContext context) {
    if (titleTextEditingController.text.isEmpty) {
      // 顯示錯誤訊息
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Title is required'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
  }

  // 編輯任務
  void editTask(BuildContext context, Task task) {
    titleTextEditingController = TextEditingController();
    titleTextEditingController.text = task.title;

    descriptionTextEditingController = TextEditingController();
    descriptionTextEditingController.text = task.description;

    categorySelected = ValueNotifier(0);
    categorySelected.value = int.parse(task.category) as int;

    prioritySelected = ValueNotifier(0);
    prioritySelected.value = int.parse(task.priority) as int;

    progressSelected = ValueNotifier(0);
    progressSelected.value = int.parse(task.progress) as int;

    pickTime.value = task.dueDay;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.current.add_task),
          content: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  // 分類
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    // 設置選單寬、高
                    // width: 200,
                    // height: 50,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Container(
                              child: Text(S.current.category, style: TextStyle(fontSize: 20),),
                              margin: EdgeInsets.fromLTRB(10, 10, 15, 10),
                            )
                        ),
                        ValueListenableBuilder(
                          valueListenable: categorySelected,
                          builder: (context, value, child) {
                            return DropdownButton(
                              value: categorySelected.value, // 設置當前選中的選項
                              items: categoryItems,  // 從 viewmodel 取得 item 資料
                              // 當選項被選擇時觸發
                              onChanged: (value) {
                                categorySelected.value = value;
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  // 優先權
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    // 設置選單寬、高
                    // width: 200,
                    // height: 50,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Container(
                              child: Text(S.current.priority, style: TextStyle(fontSize: 20),),
                              margin: EdgeInsets.fromLTRB(10, 10, 15, 10),
                            )
                        ),
                        ValueListenableBuilder(
                          valueListenable: prioritySelected,
                          builder: (context, value, child) {
                            return DropdownButton(
                              value: prioritySelected.value, // 設置當前選中的選項
                              items: priorityItems,  // 從 viewmodel 取得 item 資料
                              // 當選項被選擇時觸發
                              onChanged: (value) {
                                prioritySelected.value = value;
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  // 進度
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    // 設置選單寬、高
                    // width: 200,
                    // height: 50,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            child: Text(S.current.progress, style: TextStyle(fontSize: 20),),
                            margin: EdgeInsets.fromLTRB(10, 10, 15, 10),
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: progressSelected,
                          builder: (context, value, child) {
                            return DropdownButton(
                              value: progressSelected.value, // 設置當前選中的選項
                              items: progressItems,  // 從 viewmodel 取得 item 資料
                              // 當選項被選擇時觸發
                              onChanged: (value) {
                                progressSelected.value = value;
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  // 截止日期
                  Container(
                      margin: EdgeInsets.fromLTRB(10, 40, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(S.current.due_day, style: TextStyle(fontSize: 20),)
                          ),
                          Container(
                              child: IconButton(
                                icon: Icon(Icons.calendar_month),
                                onPressed: () {
                                  _showDatePicker(context);
                                },
                                iconSize: 25,
                              )
                          ),
                        ],
                      )
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ValueListenableBuilder(
                        valueListenable: pickTime,
                        builder: (context, value, child) {
                          return Text(pickTime.value);
                        },
                      )
                  )
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
                setBusy(true);
                globalViewModel.updateTask(
                    task.id,
                    titleTextEditingController.text,
                    descriptionTextEditingController.text,
                    categoryItems[categorySelected.value].value.toString(),
                    priorityItems[prioritySelected.value].value.toString(),
                    progressItems[progressSelected.value].value.toString(),
                    pickTime.value
                );
                setBusy(false);
                AutoRouter.of(context).pop();
              },
              child: Text(S.current.finish),
            ),
          ],
        );
      },
    );
  }

  // Firebase 新增任務
  void _writeTaskToFirebase() async{
    try {
      var random = Random();
      var currentTime = DateTime.now().millisecondsSinceEpoch;
      var randomNumber = random.nextInt(1 << 30); // 生成0到2^30-1之間的正整數
      var id = (currentTime & 0x3FFFFFFF) ^ randomNumber; // 確保結果在 31 位範圍內
      // 確保生成的數字是正整數並在範圍內
      String taskId = (id & 0x7FFFFFFF).toString(); // 取 31 位數字
      print('Function: _writeTaskToFirebase, taskId = $taskId');

      await _databaseReference.child(globalViewModel.user!.id).child('tasks').child(taskId).set({
        'title': titleTextEditingController.text,
        'description': descriptionTextEditingController.text,
        'category': categoryItems[categorySelected.value].value.toString(),
        'priority': priorityItems[prioritySelected.value].value.toString(),
        'progress': progressItems[progressSelected.value].value.toString(),
        'dueDay': pickTime.value
      }).then((_) {
        print('成功寫入任務');

        // 設定待辦事項顯示通知訊息的設定
        // _scheduleNotification(taskId, titleTextEditingController.text, pickTime.value);

        // 更新全局 Task
        setBusy(true);
        globalViewModel.updateTotalTask();
        globalViewModel.setShowTask(globalViewModel.totalTasks);
        setBusy(false);
      }).catchError((error) {
        print('寫入任務失敗: $error');
      });
    } catch (error) {
      print('Function: _writeTaskToFirebase, Failed to retrieve data: $error');
    }
  }

  // 排程通知
  /*
     問題：測試 await flutterLocalNotificationsPlugin.show(...) 能顯示通知，
          但是設定 await flutterLocalNotificationsPlugin.zonedSchedule(...) 卻
          無法顯示通知，這支 API 就是在控制每個 task 何時要通知。
   */
  void _scheduleNotification(String taskId, String taskTitle, String dueDay) async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Taipei')); // 設置本地時區
    DateTime dueDate = DateTime.parse(dueDay);
    // 將截止日期設定為當天的 00:00
    DateTime scheduledDate = DateTime(dueDate.year, dueDate.month, dueDate.day);

    // 設定通知時間為前一天的 xx:xx
    // DateTime notificationDate = scheduledDate.subtract(Duration(hours: 10, minutes:0));
    // 設定通知時間為當前時間的前 x 分鐘
    DateTime notificationDate = DateTime.now().add(Duration(minutes: 1));
    print('Notification Date: $notificationDate'); // 輸出通知時間以檢查

    bool ret = notificationDate.isAfter(DateTime.now());
    print('Check notificationDate.isAfter(DateTime.now()) status: $ret');

    if (notificationDate.isAfter(DateTime.now())) {
      var androidDetails = AndroidNotificationDetails(
        'task_channel', // channel id
        'Task Notifications', // channel name
        channelDescription: 'Channel for task notifications', // channel description
        importance: Importance.max,
        priority: Priority.high,
      );

      var generalNotificationDetails = NotificationDetails(android: androidDetails);

      try {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          int.parse(taskId), // id
          'Task Reminder', // title
          'Your task "$taskTitle" is due soon.', // body
          tz.TZDateTime.from(notificationDate, tz.local), // scheduled time in local timezone
          generalNotificationDetails, // notification details
          androidAllowWhileIdle: true, // whether to show the notification even when the device is idle
          payload: taskId, // 设置 payload，以便點擊通知時識別任務
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dateAndTime,
        );
      } catch (e) {
        print('Error scheduling notification: $e');
      }

      // 馬上顯示通知
      // await flutterLocalNotificationsPlugin.show(
      //     int.parse(taskId),
      //     taskTitle,
      //     descriptionTextEditingController.text,
      //     generalNotificationDetails);
    }
  }

  // 刪除任務
  void deleteTask(BuildContext context, String id) async{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.current.delete_task_dialog_title),
          content: Text(S.current.delete_task_dialog_description),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                AutoRouter.of(context).pop();
              },
              child: Text(S.current.no),
            ),
            TextButton(
              onPressed: () {
                setBusy(true);
                _deleteTaskFromFirebase(id);
                AutoRouter.of(context).pop();
                setBusy(false);
              },
              child: Text(S.current.yes),
            ),
          ],
        );
      },
    );
  }

  // Firebase 刪除任務
  void _deleteTaskFromFirebase(String id) async{
    try {
      await _databaseReference.child(globalViewModel.user!.id).child('tasks').child(id).remove().then((_) {
        print('Successfully deleted $id');

        // 更新全局 Task
        setBusy(true);
        if (globalViewModel.totalTasks.length == 1) {
          globalViewModel.setTotalTask(<Task>[]);
        } else {
          globalViewModel.updateTotalTask();
        }
        globalViewModel.setShowTask(globalViewModel.totalTasks);
        setBusy(false);
      }).catchError((error) {
        print('Failed to delete $id: $error');
      });
    } catch (error) {
      print('Function: _deleteTaskFromFirebase, Failed to retrieve data: $error');
    }
  }

  // 日期選擇
  void _showDatePicker(BuildContext context) async {
    DateTime now = DateTime.now();
    pickTime.value = formatter.format(now);
    DateTime firstDate = DateTime(now.year - 5);
    DateTime lastDate = DateTime(now.year + 5);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null && picked != selectedDate) {
      pickTime.value = formatter.format(picked);
    }
  }

}