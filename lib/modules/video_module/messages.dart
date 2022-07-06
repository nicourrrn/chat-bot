import 'package:chat_bot/api/api.dart';
import 'package:chat_bot/modules/base_module/messages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class VideoState extends ChangeNotifier {
  late VideoPlayerController _ctrl;
  String path;

  VideoState(this.path);

  Future<void> initialize() async {
    if (path.contains('http')){
      _ctrl = VideoPlayerController.network(path);
    } else {
      _ctrl = VideoPlayerController.file(File(path));
    }
    return await _ctrl.initialize();
  }
  Future<void> changePlaying() async {
    if (_ctrl.value.isPlaying) {
      _ctrl.pause();
    } else {
      _ctrl.play();
    }
    notifyListeners();
  }

}

class VideoMessage extends Message {
  late VideoState _state;
  late Future<void> _initializeVideoPlayerFuture;

  VideoMessage(String? path, bool isUser) : super(isUser) {
    _state = VideoState(path ??
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
    _initializeVideoPlayerFuture = _state.initialize();
  }

  @override
  Widget getWidget() {
    return TextButton (onPressed: _state.changePlaying ,
    child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _state._ctrl.value.aspectRatio,
              child: VideoPlayer(_state._ctrl),
            );
          } else {
            return Center(
              child: TextMessage(_state.path, false).getWidget(),
            );
          }
        }));
  }
}


class ImageMessage extends Message {
  String path;
  ImageMessage(this.path, bool isUser) : super(isUser);

  @override
  Widget getWidget() {
     return Image.file(File(path));
  }
  
}