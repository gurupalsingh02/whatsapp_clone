import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp_clone/Common/enums/message_enum.dart';
import 'package:whatsapp_clone/Features/chat/widgets/display_text_image_gif.dart';
import 'package:whatsapp_clone/colors.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onLeftSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  final bool isSeen;

  const MyMessageCard(
      {super.key,
      required this.message,
      required this.date,
      required this.type,
      required this.onLeftSwipe,
      required this.repliedText,
      required this.username,
      required this.repliedMessageType,
      required this.isSeen});

  @override
  Widget build(BuildContext context) {
    final bool isReplying = repliedText.isNotEmpty;
    return SwipeTo(
      onLeftSwipe: onLeftSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          child: Card(
            color: messageColor,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      right: 40, left: 10, top: 10, bottom: 30),
                  child: Column(
                    children: [
                      if (isReplying) ...[
                        Text(
                          username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: backgroundColor.withOpacity(0.5)),
                          child: DisplayTextImageGif(
                              message: repliedText, type: repliedMessageType),
                        )
                      ],
                      DisplayTextImageGif(message: message, type: type),
                    ],
                  ),
                ),
                Positioned(
                    bottom: 5,
                    right: 5,
                    child: Row(
                      children: [
                        Text(
                          date,
                          style: const TextStyle(fontSize: 10),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Icon(
                            Icons.done_all,
                            color: isSeen ? Colors.lightBlue : Colors.white,
                          ),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
