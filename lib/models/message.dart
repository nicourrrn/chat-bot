import 'package:flutter/material.dart';

abstract class Message {
  static int lastId = 0;

  Message (this.isUser, [this.moduleName]) {
    lastId ++;
  }

  late final int id = lastId;
  late final bool isUser;
  late final String? moduleName;
  DateTime createAt = DateTime.now();
  Widget getWidget();
}

class TextMessage extends Message {
  TextMessage(this.text, bool isUser, [String? moduleName]) : super(isUser, moduleName);
  String text;

  @override
  Widget getWidget() {
    return Text(text);
  }

}