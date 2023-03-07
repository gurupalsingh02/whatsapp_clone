import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Common/widgets/utils/utils.dart';
import 'package:whatsapp_clone/Features/chat/controllers/chat_controller.dart';
import 'package:whatsapp_clone/colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String recieverUserId;
  const BottomChatField({required this.recieverUserId, super.key});

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

final _messageController = TextEditingController();
bool showSendButton = false;

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  sendTextMessage() {
    if (_messageController.text.isNotEmpty) {
      ref.read(chatControllerProvider).sendTextMessage(
          context, _messageController.text.trim(), widget.recieverUserId);
      _messageController.text = '';
    } else {
      showSnakBar(context, "can't send empty message");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: TextField(
              controller: _messageController,
              onChanged: (value) {
                if (value.isEmpty) {
                  showSendButton = false;
                } else {
                  showSendButton = true;
                }
                setState(() {});
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  filled: true,
                  fillColor: appBarColor,
                  hintText: 'type a message',
                  prefixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.emoji_emotions_outlined)),
                        IconButton(onPressed: () {}, icon: Icon(Icons.gif))
                      ],
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              pickImageFromGallery(context);
                            },
                            icon: const Icon(Icons.camera_alt)),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.attach_file))
                      ],
                    ),
                  )),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: CircleAvatar(
              backgroundColor: tabColor,
              child: GestureDetector(
                onTap: () {
                  sendTextMessage();
                },
                child: Icon(
                  showSendButton ? Icons.send : Icons.mic,
                  color: Colors.white,
                ),
              )),
        )
      ],
    );
  }
}
