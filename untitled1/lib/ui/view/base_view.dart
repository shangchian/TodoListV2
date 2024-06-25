import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*
所有 view 都要 return 此類。
*/
class BaseView<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final T Function() modelProvider;
  final Function(T)? onModelReady;
  final bool keepAlive;

  const BaseView({
    super.key,
    required this.builder,
    required this.modelProvider,
    this.onModelReady,
    this.keepAlive = false,
  });

  @override
  BaseViewState<T> createState() => BaseViewState<T>();
}

class BaseViewState<T extends ChangeNotifier> extends State<BaseView<T>>
    with AutomaticKeepAliveClientMixin<BaseView<T>> {
  late T model;

  @override
  void initState() {
    super.initState();
    model = widget.modelProvider();

    if (widget.onModelReady != null) {
      widget.onModelReady!(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 利用 ChangeNotifier 進行狀態管理，並通過 ChangeNotifierProvider<T>，將 model 提供給其下層的子部件，這裡的 T 是 ChangeNotifier 的具體類型，例如 LoginViewModel。
    // Consumer 是一個 Widget，它可以讀取來自 ChangeNotifierProvider 的 model，並根據 model 的變化來重新構建其子部件。Consumer<T> 中的 builder 參數被設置為 widget.builder，這個 builder 函式將 context、model 和 widget.child 傳遞給 BaseView 中的 builder 函式。
    // widget.builder 是 BaseView 的構造函式中傳入的一個函式，它負責構建具體的界面部件。
    // 重要：當使用 AutomaticKeepAliveClientMixin 時，必須調用 super.build
    super.build(context);
    return SafeArea(
      child: ChangeNotifierProvider<T>(
        create: (context) => model,
        child: Consumer<T>(
          builder: widget.builder,
        ),
      ),
    );
  }

  // AutomaticKeepAliveClientMixin 需要實現的方法
  @override
  bool get wantKeepAlive => widget.keepAlive;
}
