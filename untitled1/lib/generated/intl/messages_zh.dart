// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add": MessageLookupByLibrary.simpleMessage("新增"),
        "addTask": MessageLookupByLibrary.simpleMessage("新增任務"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "deleteTaskDialogDescription":
            MessageLookupByLibrary.simpleMessage("是否刪除任務"),
        "deleteTaskDialogTitle": MessageLookupByLibrary.simpleMessage("刪除任務"),
        "description": MessageLookupByLibrary.simpleMessage("描述"),
        "dueDay": MessageLookupByLibrary.simpleMessage("截止日期"),
        "finish": MessageLookupByLibrary.simpleMessage("完成"),
        "google_login": MessageLookupByLibrary.simpleMessage("使用 Google 登入"),
        "logout": MessageLookupByLibrary.simpleMessage("登出"),
        "no": MessageLookupByLibrary.simpleMessage("否"),
        "priority": MessageLookupByLibrary.simpleMessage("優先權"),
        "title": MessageLookupByLibrary.simpleMessage("標題"),
        "todo_list": MessageLookupByLibrary.simpleMessage("待辦事項"),
        "yes": MessageLookupByLibrary.simpleMessage("是")
      };
}
