import 'package:chat_bot/bot_api/api.dart';
import 'package:chat_bot/bot_api/bot.dart';

import 'messages.dart';

class BaseModule extends Module {

  Message replyMessage(Bot context, List<String> args) {
    return TextMessage(args.skip(1).join(' '), false, 'BaseModule');
  }

  Message clear(Bot context, List<String> args){
    var messageCount = context.messageHistory.length;
    for (int i = context.messageHistory.length - 1; i >= 0; i--) {
      context.deleteMessage(index: i);
    }
    return TextMessage("Було виделано $messageCount повідомлень!", false, 'BaseModule');
  }

  Message plantText(Bot context, List<String> args) {
      context.addMessage(TextMessage("Добрий день!", false));
      return TextMessage("Чи вечір....", false);
  }

  Message notFound(Bot context, List<String> args) {
    return ErrorMessage("Команда не знайдена !", false);
  }

  Message dianaToDina(Bot context, List<String> args){
    var lastMessage = context.messageHistory
        .where((element) => element.isUser)
        .last as TextMessage;
    lastMessage.text = "Діна!";
    return TextMessage("Я тебе виправив...", false);
  }

  @override
  Message? execute(Bot context, List<String> args) {
    switch (args[0]) {
      case '/reply': return replyMessage(context, args);
      case '/clear': return clear(context, args);
      case 'Привіт': return plantText(context, args);
      case 'Діана' : return dianaToDina(context, args);
      default: return notFound(context, args);
    }
  }

}
