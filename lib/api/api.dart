import 'dart:collection';

import 'package:flutter/material.dart';

class Bot extends ChangeNotifier {
  final List<Message> _messageHistory = [];

  addMessage(Message message) {
    _messageHistory.add(message);
    notifyListeners();
  }

  editMessage(Message newMessage, {int? id, int? index}) {
    if (index != null) {
      _messageHistory[index] = newMessage;
      notifyListeners();
      return;
    }
    for (var i = 0; i < _messageHistory.length; i++) {
      if (_messageHistory[i].id == id) {
        _messageHistory[i] = newMessage;
        notifyListeners();
        return;
      }
    }
  }

  deleteMessage({int? index, int? id}) {
    if (index != null) {
      _messageHistory.removeAt(index);
    } else if (id != null) {
      _messageHistory.removeWhere((element) => element.id == id);
    }
    notifyListeners();
  }

  UnmodifiableListView<Message> get messageHistory =>
      UnmodifiableListView(_messageHistory);


  final Set<Module> _enabledModules = {};
  final Set<Module> _disabledModules = {};

  enableModule(Module m) {
    _disabledModules.remove(m);
    _enabledModules.add(m);
    notifyListeners();
  }

  disableModule(Module m) {
    _enabledModules.remove(m);
    _disabledModules.add(m);
    notifyListeners();
  }

  Iterable<Module> get allModules =>
      _enabledModules.followedBy(_disabledModules);

  Map<Module, Iterable<String>> get commandNames => allModules
          .map((e) => {e: e.commandNames})
          .reduce((value, element) {
        value.addAll(element);
        return value;
      });

  bool isEnable(Module m) {
    return _enabledModules.contains(m);
  }

  Future<Message?> doCommand(List<String> args) async {
    for (var module in _enabledModules) {
      var result = await module.execute(this, args);
      if (result != null) {
        return result;
      }
    }
  }

  doAndAddCommand(BuildContext context, List<String> args) async {
    var result = await doCommand(args);
    if (result != null) {
      addMessage(BaseMessage(context, result));
    }
  }
}


class BaseMessage extends Message {
  Message m;
  BuildContext context;
  BaseMessage(this.context, this.m) : super(m.isUser);

  @override
  Widget getWidget() {
    double leftMargin = isUser ? MediaQuery.of(context).size.width / 6 : 2;
    double rightMargin = isUser ? 2 : MediaQuery.of(context).size.width / 6;
    return Container(
      child: m.getWidget(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).backgroundColor,
      ),
      padding: const EdgeInsets.all(8),
      margin: EdgeInsets.only(left: leftMargin, right: rightMargin),
    );
  }

}

abstract class Module {
  Future<Message?> execute(Bot context, List<String> args);
  Iterable<String> get commandNames;
}

abstract class Message {
  static int lastId = -1;

  Message(this.isUser, [this.moduleName]) {
    lastId++;
  }

  late final int id = lastId;
  late final bool isUser;
  late final String? moduleName;
  DateTime createAt = DateTime.now();

  Widget getWidget();
}
