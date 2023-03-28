import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/Common/enums/message_enum.dart';
import 'package:whatsapp_clone/Common/widgets/utils/utils.dart';
import 'package:whatsapp_clone/Features/chat/widgets/video_player_item.dart';

class DisplayTextImageGif extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGif(
      {super.key, required this.message, required this.type});
  @override
  Widget build(BuildContext context) {
    bool isplaying = false;
    final audioPlayer = AudioPlayer();
    audioPlayer.setVolume(1);

    return type == MessageEnum.text
        ? Text(message)
        : type == MessageEnum.image
            ? CachedNetworkImage(
                imageUrl: message,
              )
            : type == MessageEnum.video
                ? VideoPlayerItem(url: message)
                : type == MessageEnum.audio
                    ? StatefulBuilder(builder: (context, setState) {
                        return IconButton(
                            onPressed: () async {
                              if (isplaying) {
                                await audioPlayer.pause();
                                setState(() {
                                  isplaying = false;
                                });
                              } else {
                                await audioPlayer.play(UrlSource(message));
                                setState(() {
                                  isplaying = true;
                                });
                              }
                            },
                            icon: Icon(
                                isplaying ? Icons.pause : Icons.play_arrow));
                      })
                    : CachedNetworkImage(imageUrl: message);
  }
}
