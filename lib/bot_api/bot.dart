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

  deleteMessage({int? index, int? id}) {
    if (index != null) {
      _messageHistory.removeAt(index);
    } else if (id != null) {
      _messageHistory.removeWhere((element) => element.id == id);
    }
    notifyListeners();
  }

  Message? doCommand(List<String> args) {
    for (var module in modules) {
      var result = module.execute(this, args);
      if (result != null) {
        return result;
      }
    }
  }
}
