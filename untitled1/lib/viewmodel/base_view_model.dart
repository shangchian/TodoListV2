/*
1.所有 ViewModel 都要繼承次類。
2.此類會引入 GlobalViewModel （存放全局狀態），若要存取、修改全局變數，須在此類撰寫 get, set 方法
3.當布局狀態有變更時，可以呼叫 setBusy() 以更新布局
*/
import 'package:flutter/cupertino.dart';
import '../locator.dart';
import 'global_view_model.dart';

class BaseViewModel extends ChangeNotifier {
  final GlobalViewModel globalViewModel = locator<GlobalViewModel>();

  bool _busy = false; // 是否忙碌中
  bool get busy => _busy;

  bool _disposed = false; // 是否已經被釋放
  bool get disposed => _disposed;

  late BuildContext _context; // 目前頁面
  BuildContext get context => _context;

  @override
  void dispose(){
    _disposed = true; // 確保 _disposed 在 super.dispose() 之前設置
    super.dispose();
  }

  @override
  void notifyListeners(){
    if(!_disposed) super.notifyListeners();
  }

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  void initViewModel(BuildContext context) {
    // 移除了 setBusy 調用，簡化了方法
    // setBusy(true);
    _context = context;
    // setBusy(false);
  }
}
