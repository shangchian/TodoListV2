import 'package:flutter/cupertino.dart';

import '../core/model/user.dart';

class GlobalViewModel extends ChangeNotifier {
  // user
  User? _user = null;
  User? get user => _user;
  void setUser(User? user) {
    this._user = user;
  }
}