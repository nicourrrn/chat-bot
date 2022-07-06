import 'dart:core';

import 'package:chat_bot/api/api.dart';

import 'messages.dart';

class BaseModule extends Module {
  var wasCleaned = 0;

  Future<Message> replyMessage(Bot context, List<String> args) async {
    return TextMessage(args.skip(1).join(' '), false, 'BaseModule');
  }

  Future<Message> clear(Bot context, List<String> args) async {
    var messageCount = context.messageHistory.length;
    for (int i = context.messageHistory.length - 1; i >= 0; i--) {
      context.deleteMessage(index: i);
    }
    wasCleaned ++;
    return TextMessage(
        "Було виделано $messageCount повідомлень! $wasCleaned рази!", false, 'BaseModule');
  }

  Future<Message> plantText(Bot context, List<String> args) async {
    context.addMessage(TextMessage("Добрий день!", false));
    return TextMessage("Чи вечір....", false);
  }

  Future<Message> notFound(Bot context, List<String> args) async {
    return ErrorMessage("Команда не знайдена !", false);
  }

  Future<Message> dianaToDina(Bot context, List<String> args) async {
    var messageId = (context.messageHistory
        .where((element) => element.isUser)
        .last as TextMessage).id;
    Future.delayed(const Duration(seconds: 1), () {
      var newMessage = TextMessage("Діна", true);
      context.editMessage(newMessage, id: messageId);
    });
    return TextMessage("Я тебе виправлю... ", false);
  }

  Future<Message> start(Bot context, List<String> args) async {
    return TextMessage("Приємно познайомитись !", false);
  }

  Future<Message> calculation(Bot context, List<String> args) async {
    return TextMessage("Я поки що так не вмію", false);
  }

  late Map<String, Future<Message?> Function(Bot, List<String>)> commands;

  BaseModule() {
    commands = {
      '/reply': replyMessage,
      '/clear': clear,
      '/start': start,
      '/calculation': calculation,
    };
  }

  @override
  Future<Message?> execute(Bot context, List<String> args) async {
    var command = commands[args[0]];
    if (command != null) {
      return command(context, args);
    }
    switch (args[0]) {
      case 'Привіт':
        return plantText(context, args);
      case 'Діана':
        return dianaToDina(context, args);
      // default:
      //   return notFound(context, args);
    }
  }

  @override
  Iterable<String> get commandNames => commands.keys;
}
