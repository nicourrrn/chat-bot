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
      body: Column(
        children: const [
          Center(child: Text("Тут нічого немає..."))
        ],
      ),
    );
  }

}