import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DemoVideoPlayer extends StatefulWidget {
  const DemoVideoPlayer({super.key});

  @override
  State<DemoVideoPlayer> createState() => _DemoVideoPlayerState();
}

class _DemoVideoPlayerState extends State<DemoVideoPlayer>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  bool isPlaying = false;
  @override
  void initState() {
    // TODO: implement initState

    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.addListener(() {
      if (_controller.value.isPlaying) {
        isPlaying = true;
      } else {
        isPlaying = false;
      }
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
            setState(() {});
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: SizedBox(
                width: double.infinity,
                height: 180,
                child: VideoPlayer(
                  _controller,
                ),
              ),
            ),
          ),
        ),
        if (!_controller.value.isPlaying)
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  _controller.play();
                  setState(() {});
                },
                child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(Icons.play_arrow)),
              ),
            ),
          )
      ],
    );
  }
}
