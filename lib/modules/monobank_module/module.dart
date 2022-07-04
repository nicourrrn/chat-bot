import 'package:chat_bot/api/api.dart';
import 'package:chat_bot/modules/base_module/messages.dart';

import 'package:monobank_api/monobank_api.dart';

class MonoModule extends Module {
  late Map<String, Future<Message?> Function(Bot, List<String>)> commands;
  late final MonoAPI monoApi;

  Future<Message?> getClientInfo(Bot context, List<String> args) async {
    var clientInfo = await monoApi.clientInfo();
    var text = "${clientInfo.name}:\n";
    text += clientInfo.accounts
        .map((e) => "${e.cards.first.mask}: ${e.balance}")
        .join('\n');
    return TextMessage(text, false);
  }

  Future<Message?> getCurrency(Bot context, List<String> args) async {
    var currency = await monoApi.currency();
    var text = currency
        .map((CurrencyInfo e) =>
            "${e.currencyA.code}/${e.currencyB.code}: ${e.rateBuy}/${e.rateSell}")
        .join('\n');
    return TextMessage(text, false);
  }

  MonoModule(String token) {
    monoApi = MonoAPI(token);
    commands = {
      '/get_me': getClientInfo,
      '/currency': getCurrency,
    };
  }

  @override
  Iterable<String> get commandNames => commands.keys;

  @override
  Future<Message?> execute(Bot context, List<String> args) async {
    var command = commands[args[0]];
    if (command != null) {
      return command(context, args);
    }
  }
}
