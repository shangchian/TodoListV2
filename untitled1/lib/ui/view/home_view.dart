import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/ui/view/base_view.dart';
import 'package:untitled1/viewmodel/home_view_model.dart';

import '../../generated/l10n.dart';

@RoutePage()
class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeViewModel _viewModel;

  /*
    initState() 會在以下情況下被調用：
      1. State對象被創建時：當 StatefulWidget 第一次插入 widget 樹時，initState() 會被調用一次。這通常在 widget 被構建並插入樹中時發生。
      2. 只被調用一次：在 widget 的整個生命周期內，initState() 只會被調用一次。這與 build() 方法不同，後者會被多次調用。

    主要用途:
      1. 初始化狀態：在 initState() 中，你可以初始化一些狀態變數。
      2. 訂閱服務：比如監聽 Stream 或設置定時器。
      3. 與框架交互：執行依賴於框架的操作，如 context 或 widget 的參考。

    initState() 中的注意事項
      1. 調用 super.initState()：在 initState() 中，你應該首先調用 super.initState()，以確保父類的初始化邏輯得以執行。
      2. 避免使用 context 執行某些操作：在 initState() 中不應該使用 context 執行會導致構建 widget 的操作，因為 widget 樹可能尚未完全構建。使用 WidgetsBinding.instance.addPostFrameCallback 來延遲執行這些操作。
   */
  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel();
    _viewModel.initViewModel(context);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 主要通過 ChangeNotifier 和 ValueListenableBuilder 來管理狀態和更新 UI。
    // 當 HomeViewModel 或 ValueNotifier 發生變化時，對應的 Consumer 和 ValueListenableBuilder 會自動重新構建其子 widget，從而實現畫面的更新。
    return ChangeNotifierProvider<HomeViewModel>(
      create: (_) => _viewModel,
      child: Consumer<HomeViewModel>( // Consumer widget 用於監聽 HomeViewModel 的變化。當 HomeViewModel 發出通知時（即 notifyListeners() 被調用），Consumer 的 builder 會被重新調用，從而更新 UI。
        builder: (context, model, child) {
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
                    ValueListenableBuilder( // ValueListenableBuilder 用於監聽 ValueNotifier 類型的變量。(in showTasks)當 ValueNotifier 的值發生變化時，ValueListenableBuilder 會自動重新構建它的子 widget。
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
        },
      ),
    );
  }
}


/*
    ChangeNotifier 和 ChangeNotifierProvider
      ChangeNotifier 是一個通知器類，通常用於管理應用中的全局狀態。當狀態發生變化時，它會通知所有依賴它的監聽器，從而觸發 UI 更新。
      用途：適用於需要在整個應用或一個大範圍內共享和管理狀態的場景。
      實現：通過 ChangeNotifierProvider 提供狀態，並通過 Consumer 或 Provider.of 監聽狀態變化。

    ValueListenableBuilder
      ValueListenableBuilder 用於監聽 ValueNotifier 的變化。ValueNotifier 是一個輕量級的通知器，適用於簡單的、局部的狀態管理。
      用途：適用於需要監聽單一值變化的場景，通常在較小範圍內使用。
      實現：通過監聽 ValueNotifier 的值變化來更新特定的 UI 部分。

    為什麼同時使用兩者？
    同時使用 ChangeNotifier 和 ValueListenableBuilder 的原因是為了更好地組織和管理狀態，以及優化性能：
    1. 分離關注點：
        1.1 ChangeNotifier 適用於全局狀態管理，如用戶登錄狀態、全局配置等。
        1.2 ValueNotifier 適用於局部狀態管理，如特定的任務列表顯示狀態等。
    2. 性能優化：
        2.1 ValueNotifier 比 ChangeNotifier 更輕量，適用於頻繁更新的小範圍狀態。
            使用 ValueListenableBuilder 只會重新構建特定部分的 UI，而不會影響整個依賴 ChangeNotifier 的 widget 樹，
            從而減少不必要的重建。
    3. 代碼簡潔：
        3.1 ValueNotifier 和 ValueListenableBuilder 使代碼更簡潔和易讀，特別是在處理簡單的值變化時。
        3.2 ChangeNotifier 提供了更豐富的狀態管理功能，適用於更複雜的場景。

    總結
      同時使用 ChangeNotifier 和 ValueListenableBuilder 是為了在不同場景下使用最合適的狀態管理工具。
      ChangeNotifier 用於管理較大範圍的全局狀態，而 ValueNotifier 則用於管理特定的小範圍狀態，從而提高代碼的組織性和性能。
 */