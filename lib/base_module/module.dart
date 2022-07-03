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

  @override
  Message? execute(Bot context, List<String> args) {
    switch (args[0]) {
      case '/reply': return replyMessage(context, args);
      case '/clear': return clear(context, args);
    }
  }

}
