import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'package:chat_bot/modules/base_module/messages.dart';
import 'package:chat_bot/api/api.dart';

class ScreenState extends ChangeNotifier{
  var _showCommands = false;

  bool get showCommands => _showCommands;
  changeShowCommands() {
    _showCommands = !_showCommands;
    notifyListeners();
  }

}

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  var userTextCtrl = TextEditingController();
  var scrollMessageCtrl = ScrollController();

  void scrollToEnd() {
    final position = scrollMessageCtrl.position.maxScrollExtent;
    scrollMessageCtrl.animateTo(position,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }

  List<Row> getCommandsHelper(Bot context) {
    var commands = context.commandNames.toList();
    List<Row> result = [];
    for (var i = 0; i < commands.length; i += 3) {
      var end = i + 3 < commands.length ? i + 3 : commands.length - 1;
      var commandsRow = commands.getRange(i, end);
      result.add(Row(
          children: commandsRow
              .map((e) => Expanded(child: TextButton(
                  child: Text(e),
                  onPressed: () {
                    userTextCtrl.text = e;
                  })))
              .toList()));
    }
    var divByThree = commands.length % 3;
    if (divByThree!= 0) {
      result.add(Row(
        children: commands.getRange(commands.length - divByThree, commands.length)
        .map((e) => Expanded(child: TextButton(
          child: Text(e),
          onPressed: (){
            userTextCtrl.text = e;
          },
        ))).toList(),
      ));
    }
    return result;
  }


  @override
  Widget build(BuildContext context) {
    var bot = context.watch<Bot>();
    var screenState = context.watch<ScreenState>();

    // Возможно перерассмотреть способ прокрутки
    // Как вариант вынести область прокрути в другой класс
    // или сделать более грамотный scrollMessageCtrl.addListener
    WidgetsBinding.instance?.addPostFrameCallback((duration) => scrollToEnd());

    return Scaffold(
        appBar: AppBar(
          title: const Text("Chat bot"),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.home),
                title: const Text("Головна"),
                onTap: () {
                  Navigator.of(context).popAndPushNamed('/');
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Налаштування"),
                onTap: () {
                  Navigator.of(context).popAndPushNamed('/setting');
                },
              )
            ],
          ),
        ),
        body: Column(children: [
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ListView.builder(
                      controller: scrollMessageCtrl,
                      shrinkWrap: true,
                      itemCount: bot.messageHistory.length,
                      itemBuilder: (context, i) {
                        var msg = bot.messageHistory[i];
                        return Container(
                          child: msg.getWidget(),
                          alignment: msg.isUser
                              ? AlignmentDirectional.centerEnd
                              : AlignmentDirectional.centerStart,
                          padding: const EdgeInsets.only(bottom: 5),
                        );
                      }))),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              color: Theme.of(context).colorScheme.background,
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                FloatingActionButton.small(
                    child: const Icon(Icons.add),
                    shape: const CircleBorder(),
                    elevation: 0,
                    backgroundColor: Theme.of(context).backgroundColor,
                    onPressed: screenState.changeShowCommands),
                Expanded(
                    child: TextField(
                        controller: userTextCtrl,
                        decoration: const InputDecoration(
                          hintText: "Ваше повідомлення",
                          border: InputBorder.none,
                          // border: OutlineInputBorder(
                          //     borderRadius: BorderRadius.circular(15),
                          //     borderSide: BorderSide.none),
                          // filled: true,
                          // fillColor: Colors.blue.shade100
                        ))),
                FloatingActionButton.small(
                    elevation: 0,
                    backgroundColor: Theme.of(context).backgroundColor,
                    child: const Icon(Icons.send),
                    onPressed: () async {
                      if (userTextCtrl.text == '') {
                        return;
                      }
                      var text = userTextCtrl.text;
                      userTextCtrl.text = '';
                      bot.addMessage(TextMessage(text, true));
                      bot.doAndAddCommand(text.split(' '));
                    })
              ])),
          SizedBox(
              height: screenState.showCommands ? MediaQuery.of(context).size.height / 3.5 : 0,
              child: ListView(
                children: getCommandsHelper(bot),
              ))
        ]));
  }
}
