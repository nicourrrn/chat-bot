import 'dart:collection';

import 'package:flutter/material.dart';

class Bot extends ChangeNotifier {
  final List<Message> _messageHistory = [];
  List<Module> modules = [];

  addMessage(Message message) {
    _messageHistory.add(message);
    notifyListeners();
  }
  // TODO Добавить редактирование посредством замещения ссылки
  // (передавать не ид а сообщение как в delete)
  editMessage(int messageId, Message newMessage) {
    for (var i = 0; i < _messageHistory.length; i++) {
      if (_messageHistory[i].id == messageId){
        _messageHistory[i] = newMessage;
        break;
      }
    }
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

  doAndAddCommand(List<String> args) async {
    var result = await doCommand(args);
    if (result != null) {
      addMessage(result);
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


abstract class Module{
  Future<Message?> execute(Bot context, List<String> args);
  Iterable<String> get commandNames;
}

abstract class Message {
  static int lastId = -1;

  Message (this.isUser, [this.moduleName]) {
    lastId ++;
  }

  late final int id = lastId;
  late final bool isUser;
  late final String? moduleName;
  DateTime createAt = DateTime.now();
  Widget getWidget();
}