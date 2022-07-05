import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_bot/api/api.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bot = context.watch<Bot>();

    return Scaffold(
      appBar: AppBar(title: const Text("Chat bot")),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Головна"),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Налаштування"),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/setting');
              },
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: bot.allModules.length,
            itemBuilder: (context, i) {
              var module = bot.allModules.skip(i).first;

              return ListTile(
                title: Text(module.runtimeType.toString(), style: TextStyle(
                  color: bot.isEnable(module) ? Theme.of(context).disabledColor : null
                )),
                onTap: bot.isEnable(module) ? () => bot.disableModule(module) : bot.enableModule(module),
              );
            },
          ))
        ],
      ),
    );
  }
}
