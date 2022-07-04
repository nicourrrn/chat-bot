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

  UnmodifiableListView<Message> get messageHistory =>
      UnmodifiableListView(_messageHistory);

  deleteMessage({int? index, int? id}) {
    if (index != null) {
      _messageHistory.removeAt(index);
    } else if (id != null) {
      _messageHistory.removeWhere((element) => element.id == id);
    }
    notifyListeners();
  }

  Future<Message?> doCommand(List<String> args) async {
    for (var module in modules) {
      var result = await module.execute(this, args);
      if (result != null) {
        return result;
      }
    }
  }

  Iterable<String> get commandNames {
    List<String> templateNames = [];
    for (var element in modules) {
      templateNames += element.commandNames.toList();
    }
    return templateNames;
  }
}
