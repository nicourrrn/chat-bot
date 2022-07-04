import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_bot/api/api.dart';
import 'package:chat_bot/modules/base_module/module.dart';
import 'package:chat_bot/modules/monobank_module/module.dart';

import 'package:chat_bot/screen/root.dart';
import 'package:chat_bot/screen/setting.dart';

Bot botWithModules() {
  var bot = Bot();
  bot.modules.add(MonoModule('uiQEBoAL2lI6XkMRKHYAy-fBnaYjNKKSbzFIhtLxJh3k'));
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
      darkTheme: ThemeData.dark(),
      routes: {
        '/': (context) => MainScreen(),
        '/setting': (context) => const Setting(),
      },
    );
  }
}
