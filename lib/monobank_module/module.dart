import 'package:chat_bot/bot_api/api.dart';
import 'package:chat_bot/bot_api/bot.dart';
import 'package:chat_bot/base_module/messages.dart';
import 'package:monobank_api/monobank_api.dart';

class MonoModule extends Module {
  late Map<String, Future<Message?> Function(Bot, List<String>)> commands;
  late final MonoAPI monoApi;

  Future<Message?> getClientInfo(Bot context, List<String> args) async {
    var clientInfo = await monoApi.clientInfo();
    return TextMessage(clientInfo.name, false);
  }

  MonoModule(String token) {
    monoApi = MonoAPI(token);
    commands = {
      '/get_me': getClientInfo,
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