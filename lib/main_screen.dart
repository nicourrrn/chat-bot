import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_bot/bot_api/bot.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'base_module/messages.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  var userTextCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var bot = context.watch<Bot>();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Hello from app"),
        ),
        body: Column(children: [
          Expanded(
              child: ListView.builder(
                  itemCount: bot.messageHistory.length,
                  itemBuilder: (context, i) {
                    var msg = bot.messageHistory[i];
                    return Container(
                      child: msg.getWidget(),
                      alignment: msg.isUser
                          ? AlignmentDirectional.centerEnd
                          : AlignmentDirectional.centerStart,
                    );
                  })),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Expanded(child: TextField(
                      controller: userTextCtrl,
                      decoration: InputDecoration(
                          hintText: "Ваше повідомлення",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none
                          ),
                          filled: true,
                          fillColor: Colors.blue.shade100))),
                  OutlinedButton(
                      child: const Text("Send"),
                      onPressed: () {
                        if (userTextCtrl.text == '') {
                          return;
                        }
                        var text = userTextCtrl.text;
                        bot.addMessage(TextMessage(text, true));
                        var result = bot.doCommand(text.split(' '));
                        bot.addMessage(result);
                        userTextCtrl.text = '';
                      })
                ])),
        ]));
  }
}