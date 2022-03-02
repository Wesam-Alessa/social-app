
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final bool isOnlineVideo;
  const VideoPlayerWidget({required this.url,required this.isOnlineVideo}) ;
  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late BetterPlayerController _betterPlayerController;
  late BetterPlayerDataSource _betterPlayerDataSource;
  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
    BetterPlayerConfiguration(
      aspectRatio: 16/9,
      autoPlay: false,
      looping: true,
    );
    _betterPlayerDataSource = BetterPlayerDataSource(
      widget.isOnlineVideo?BetterPlayerDataSourceType.network
          :BetterPlayerDataSourceType.file,
      widget.url
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(_betterPlayerDataSource);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
          aspectRatio: 16/9,
          child: BetterPlayer(controller: _betterPlayerController),
    );
  }
}