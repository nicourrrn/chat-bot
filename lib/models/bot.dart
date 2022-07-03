import 'dart:collection';

import 'package:flutter/material.dart';
import 'message.dart';
import 'abstract.dart';

class Bot extends ChangeNotifier {
  final List<Message> _messageHistory = [];
  List<Module> modules = [];

  addMessage(Message message) {
    _messageHistory.add(message);
  }

  UnmodifiableListView get messageHistory => UnmodifiableListView(_messageHistory);

  Result doCommand(List<String> args) {
    for (var module in modules) {
      var result = module.execute(this, args);
      if (result != null) {
        return result;
      }
    }
    return NullResult();
  }
}

class NullResult extends Result{
  @override
  Widget get() {
    return const Text("Команда не знайдена");
  }
}