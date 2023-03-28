import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerItem extends StatefulWidget {
  final String url;
  const VideoPlayerItem({super.key, required this.url});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

late CachedVideoPlayerController videoPlayerController;
bool playing = false;
Duration position = const Duration(seconds: 0);

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  @override
  void initState() {
    super.initState();
    videoPlayerController = CachedVideoPlayerController.network(widget.url)
      ..initialize().then((value) => videoPlayerController.setVolume(1));
    videoPlayerController.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(videoPlayerController),
          Align(
            alignment: Alignment.center,
            child: IconButton(
                onPressed: () async {
                  if (playing) {
                    videoPlayerController.pause();
                  } else {
                    videoPlayerController.play();
                  }
                  playing = !playing;

                  setState(() {});
                },
                icon: playing
                    ? const Icon(Icons.pause_circle_filled)
                    : const Icon(Icons.play_circle_fill)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: VideoProgressIndicator(videoPlayerController,
                colors: const VideoProgressColors(
                    backgroundColor: Colors.grey,
                    playedColor: Colors.lightBlue,
                    bufferedColor: Colors.white),
                padding: const EdgeInsets.all(12),
                allowScrubbing: true),
          )
        ],
      ),
    );
  }
}
