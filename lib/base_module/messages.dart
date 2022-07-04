import 'package:flutter/material.dart';
import 'package:chat_bot/bot_api/api.dart';

class TextMessage extends Message {
  TextMessage(this.text, bool isUser, [String? moduleName]) : super(isUser, moduleName);
  String text;

  @override
  Widget getWidget() {
    return Container(
      child: SelectableText(text),
      decoration: BoxDecoration(
        color: Colors.blue.shade200,
        borderRadius: BorderRadius.circular(15),
      ),
    padding: const EdgeInsets.all(10),
    );
  }

}

class ErrorMessage extends Message {
  ErrorMessage(this.text, bool isUser, [String? moduleName = 'BaseModule']) : super(isUser, moduleName);
  String text;

  @override
  Widget getWidget() {
    return Container(
      child: SelectableText(text),
      decoration: BoxDecoration(
        color: Colors.red.shade200,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(10),
    );
  }
}