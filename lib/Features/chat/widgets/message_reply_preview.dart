import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/Features/chat/widgets/display_text_image_gif.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({super.key});
  cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Text(
              messageReply!.isMe ? 'Me' : 'Opposite',
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
            GestureDetector(
              onTap: () {
                cancelReply(ref);
              },
              child: const Icon(Icons.close),
            )
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        DisplayTextImageGif(
            message: messageReply.message, type: messageReply.messageEnum)
      ],
    );
  }
}
