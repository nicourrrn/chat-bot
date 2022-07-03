import 'package:chat_bot/bot_api/api.dart';
import 'package:chat_bot/bot_api/bot.dart';

import 'messages.dart';

class BaseModule extends Module {

  Message replyMessage(Bot context, List<String> args) {
    return TextMessage(args.skip(1).join(' '), false, 'BaseModule');
  }

  @override
  Message? execute(Bot context, List<String> args) {
    switch (args[0]) {
      case '/reply': return replyMessage(context, args);
    }
  }

}
