import 'package:flutter/material.dart';
import 'bot.dart';


abstract class Module{
  Message? execute(Bot context, List<String> args);
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
