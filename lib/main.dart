import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_screen.dart';

import 'package:chat_bot/bot_api/bot.dart';

import 'package:chat_bot/base_module/module.dart';
import 'package:chat_bot/monobank_module/module.dart';

Bot botWithModules() {
  var bot = Bot();
  bot.modules.add(MonoModule(''));
  bot.modules.add(BaseModule());

  return bot;
}

void main() {
  var bot = botWithModules();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: bot),
        ChangeNotifierProvider(create: (context) => ScreenState())
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}
