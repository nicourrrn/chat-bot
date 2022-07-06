import 'package:chat_bot/api/api.dart';
import 'package:chat_bot/modules/base_module/messages.dart';
import 'package:chat_bot/modules/video_module/messages.dart';
import 'package:flutter/cupertino.dart';

class VideoViewModule extends Module {

  late Map<String, Future<Message?> Function(Bot, List<String>)> commands;

  Future<Message?> playVideo(Bot context, List<String> args) async {
    var path = args[1] == '' ? null : args[1];
    context.addMessage(TextMessage(path ?? "Default link", false));
    return VideoMessage(path, false);
  }

  VideoViewModule() {
    commands = {
      '/video': playVideo,
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