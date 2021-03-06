import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:chat_bot/modules/base_module/messages.dart';
import 'package:chat_bot/api/api.dart';

class ScreenState extends ChangeNotifier {
  var _showCommands = false;
  var _showSendFile = false;

  bool get showCommands => _showCommands;
  bool get showSendFile => _showSendFile;

  changeShowSendFile() {
    _showSendFile = !_showSendFile;
    _showCommands = false;
    notifyListeners();
  }

  changeShowCommands() {
    _showCommands = !_showCommands;
    _showSendFile = false;
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

  List<Widget> getCommandsHelper(Bot context, BuildContext appContext) {
    getButton(String e) => Expanded(
            child: Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(appContext).backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
          child: TextButton(
            child: Text(e),
            onPressed: () => userTextCtrl.text = e,
          ),
        ));

    List<Widget> modulesCommand = [];
    var commands = context.commandNames;
    commands.removeWhere((key, value) => !context.isEnable(key));
    for (var row in commands.entries) {
      List<List<String>> moduleCommands = [[]];
      for (var c = 0; c < row.value.length; c++) {
        if (c % 3 == 0) {
          moduleCommands.add([]);
        }
        moduleCommands.last.add(row.value.skip(c).first + " ");
      }
      modulesCommand
          .add(Padding(child: Text(row.key.runtimeType.toString(), style: Theme.of(appContext).textTheme.subtitle2),
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),));

      modulesCommand
          .addAll([for (var r in moduleCommands) Row(children: r.map((e) => getButton(e)).toList())]);
    }

    return modulesCommand;
  }

  @override
  Widget build(BuildContext context) {
    var bot = context.watch<Bot>();
    var screenState = context.watch<ScreenState>();

    // ???????????????? ?????????????????????????????? ???????????? ??????????????????
    // ?????? ?????????????? ?????????????? ?????????????? ???????????????? ?? ???????????? ??????????
    // ?????? ?????????????? ?????????? ?????????????????? scrollMessageCtrl.addListener
    WidgetsBinding.instance?.addPostFrameCallback((duration) => scrollToEnd());

    return Scaffold(
        appBar: AppBar(
          title: const Text("Chat bot"),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("??????????????"),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("????????????????????????"),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/setting');
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
              color: Theme.of(context).colorScheme.background,
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                FloatingActionButton.small(
                    heroTag: 'showMenu',
                    child: screenState._showCommands ? const Icon(Icons.remove) : const Icon(Icons.add) ,
                    shape: const CircleBorder(),
                    elevation: 0,
                    backgroundColor: Theme.of(context).backgroundColor,
                    onPressed: screenState.changeShowCommands),
                FloatingActionButton.small(
                  heroTag: 'showFiles',
                  child: const Icon(Icons.create),
                  shape: const CircleBorder(),
                  elevation: 0,
                  backgroundColor: Theme.of(context).backgroundColor,
                  onPressed: screenState.changeShowSendFile,
                ),
                Expanded(
                    child: TextField(
                        controller: userTextCtrl,
                        decoration: const InputDecoration(
                          hintText: "???????? ????????????????????????",
                          border: InputBorder.none,
                        ))),
                FloatingActionButton.small(
                    heroTag: "sendMessage",
                    elevation: 0,
                    backgroundColor: Theme.of(context).backgroundColor,
                    child: const Icon(Icons.send),
                    onPressed: () async {
                      if (userTextCtrl.text == '') {
                        return;
                      }
                      var text = userTextCtrl.text;
                      userTextCtrl.text = '';
                      bot.addMessage(BaseMessage(context, TextMessage(text, true)));
                      bot.doAndAddCommand(context, text.split(' '));
                    })
              ])),
          SizedBox(
              height: screenState.showCommands
                  ? MediaQuery.of(context).size.height / 3.5
                  : 0,
              child: ListView(
                children: getCommandsHelper(bot, context),
              )),
          SizedBox(
            height: screenState.showSendFile
                ? MediaQuery.of(context).size.height / 3.5
                : 0,
            child: ListView(
              children: [
                ElevatedButton(onPressed: () => bot.doAndAddCommand(context, ['/video', '']), child: const Text('Video')),
                ElevatedButton(onPressed: () => bot.doAndAddCommand(context, ['/image', '']), child: const Text('Image'))
              ],
            )
          )
        ]));
  }
}
