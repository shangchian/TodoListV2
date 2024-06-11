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
    print("====================homeview build");
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
              // 登出
              TextButton(
                onPressed: () {
                  model.logout(context);
                },
                child: Text(
                  S.current.logout,
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              ValueListenableBuilder(
                  valueListenable: model.globalViewModel.showTasks,
                  builder: (context, value, child) {
                    return ListView.builder(
                      itemCount: model.globalViewModel.showTasks.value.length,
                      itemBuilder: (context, index) {
                        // 任務項目
                        return InkWell(
                          onTap: () {
                            model.editTask(context, model.globalViewModel.showTasks.value[index]);
                          },
                          onLongPress: () {
                            model.deleteTask(context, model.globalViewModel.showTasks.value[index].id);
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 3, 10, 3),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(12),
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // 進度
                                    Expanded(
                                      child: Text(model.getProgressFromValue(model.globalViewModel.showTasks.value[index].progress)),
                                    ),
                                    // 截止日期
                                    Text(model.globalViewModel.showTasks.value[index].dueDay)
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // 標題
                                    Expanded(
                                      child: Text(
                                        model.globalViewModel.showTasks.value[index].title,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // 優先權
                                    Text(S.current.priority + ":" + model.getPriorityFromValue(model.globalViewModel.showTasks.value[index].priority))
                                  ],
                                ),
                                // 描述
                                Text(model.globalViewModel.showTasks.value[index].description),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
              ),
              // 排序任務按鈕
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.all(30),
                child: FloatingActionButton.extended(
                  heroTag: 'sortButton',
                  onPressed: () {
                    model.sortTask(context);
                  },
                  label: Text(S.current.sort),
                  icon: Icon(Icons.filter_list_alt),
                ),
              ),
              // 新增任務按鈕
              Container(
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.all(30),
                child: FloatingActionButton.extended(
                  heroTag: 'addButton',
                  onPressed: () {
                    model.addTask(context);
                  },
                  label: Text(S.current.add),
                  icon: Icon(Icons.add),
                ),
              )
            ],
          ),
        );
      },
      modelProvider: () => HomeViewModel(),
    );
  }
}
