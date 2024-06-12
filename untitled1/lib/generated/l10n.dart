// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Todo List`
  String get todo_list {
    return Intl.message(
      'Todo List',
      name: 'todo_list',
      desc: '',
      args: [],
    );
  }

  /// `Login With Google`
  String get google_login {
    return Intl.message(
      'Login With Google',
      name: 'google_login',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Add Task`
  String get add_task {
    return Intl.message(
      'Add Task',
      name: 'add_task',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get finish {
    return Intl.message(
      'Finish',
      name: 'finish',
      desc: '',
      args: [],
    );
  }

  /// `Priority`
  String get priority {
    return Intl.message(
      'Priority',
      name: 'priority',
      desc: '',
      args: [],
    );
  }

  /// `Due Day`
  String get due_day {
    return Intl.message(
      'Due Day',
      name: 'due_day',
      desc: '',
      args: [],
    );
  }

  /// `Delete Task`
  String get delete_task_dialog_title {
    return Intl.message(
      'Delete Task',
      name: 'delete_task_dialog_title',
      desc: '',
      args: [],
    );
  }

  /// `Whether to delete the task?`
  String get delete_task_dialog_description {
    return Intl.message(
      'Whether to delete the task?',
      name: 'delete_task_dialog_description',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Low`
  String get priority_low {
    return Intl.message(
      'Low',
      name: 'priority_low',
      desc: '',
      args: [],
    );
  }

  /// `Medium`
  String get priority_med {
    return Intl.message(
      'Medium',
      name: 'priority_med',
      desc: '',
      args: [],
    );
  }

  /// `High`
  String get priority_high {
    return Intl.message(
      'High',
      name: 'priority_high',
      desc: '',
      args: [],
    );
  }

  /// `Not Started`
  String get progress_not_started {
    return Intl.message(
      'Not Started',
      name: 'progress_not_started',
      desc: '',
      args: [],
    );
  }

  /// `In Progress`
  String get progress_in_progress {
    return Intl.message(
      'In Progress',
      name: 'progress_in_progress',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get progress_completed {
    return Intl.message(
      'Completed',
      name: 'progress_completed',
      desc: '',
      args: [],
    );
  }

  /// `Progress`
  String get progress {
    return Intl.message(
      'Progress',
      name: 'progress',
      desc: '',
      args: [],
    );
  }

  /// `Sort`
  String get sort {
    return Intl.message(
      'Sort',
      name: 'sort',
      desc: '',
      args: [],
    );
  }

  /// `Sort Task`
  String get sort_task {
    return Intl.message(
      'Sort Task',
      name: 'sort_task',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Tags`
  String get tag {
    return Intl.message(
      'Tags',
      name: 'tag',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `category`
  String get category {
    return Intl.message(
      'category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `personal`
  String get category_personal {
    return Intl.message(
      'personal',
      name: 'category_personal',
      desc: '',
      args: [],
    );
  }

  /// `work`
  String get category_work {
    return Intl.message(
      'work',
      name: 'category_work',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
