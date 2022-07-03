import 'dart:collection';

import 'package:flutter/material.dart';
import 'api.dart';

class Bot extends ChangeNotifier {
  final List<Message> _messageHistory = [];
  List<Module> modules = [];

  addMessage(Message message) {
    _messageHistory.add(message);
    notifyListeners();
  }

  UnmodifiableListView<Message> get messageHistory => UnmodifiableListView(_messageHistory);

  Message doCommand(List<String> args) {
    for (var module in modules) {
      var result = module.execute(this, args);
      if (result != null) {
        return result;
      }
    }
    return _NullResult();
  }
}

class _NullResult extends Message{
  _NullResult() : super(false);

  @override
  Widget getWidget() {
    return const Text("Команда не знайдена");
  }
}
