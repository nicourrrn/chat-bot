import 'package:chat_bot/base_module/messages.dart';
import 'package:chat_bot/base_module/module.dart';
import 'package:chat_bot/bot_api/bot.dart';
import 'package:chat_bot/bot_api/api.dart';

import 'package:test/test.dart';

void main(){
  test('Test message id', () async {
    var bot = Bot();
    bot.addMessage(TextMessage("Hello my app", true));
    expect(Message.lastId, 0);
    var message = TextMessage("Hello my father", false, "root");
    expect(message.id, 1);
  });
  test('Test bot reply', () async {
    var bot = Bot();
    bot.modules.add(BaseModule());
    var result = bot.doCommand(['/reply', 'hello', 'my drug']);
    expect((result as TextMessage).text, "hello my drug");
  });
}