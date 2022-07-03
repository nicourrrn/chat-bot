import 'package:chat_bot/models/bot.dart';
import 'package:chat_bot/models/message.dart';

import 'package:test/test.dart';

void main(){
  test('Text message id', () async {
    var bot = Bot();
    bot.addMessage(TextMessage("Hello my app", true));
    expect(Message.lastId, 0);
    var message = TextMessage("Hello my father", false, "root");
    expect(message.id, 1);
  });
}