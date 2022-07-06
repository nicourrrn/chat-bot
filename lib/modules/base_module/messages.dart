import 'package:flutter/material.dart';
import 'package:chat_bot/api/api.dart';

class TextMessage extends Message {
  TextMessage(this.text, bool isUser, [String? moduleName]) : super(isUser, moduleName);
  String text;

  @override
  Widget getWidget() {
    return SelectableText(text);
  }

}
