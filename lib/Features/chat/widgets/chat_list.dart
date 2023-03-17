import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/Common/enums/message_enum.dart';
import 'package:whatsapp_clone/Common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/Common/widgets/loader.dart';
import 'package:whatsapp_clone/Features/auth/repositories/auth_repository.dart';
import 'package:whatsapp_clone/Features/chat/controllers/chat_controller.dart';
import 'package:whatsapp_clone/Features/chat/widgets/my_message_card.dart';
import 'package:whatsapp_clone/Features/chat/widgets/sender_message_card.dart';
import 'package:whatsapp_clone/Models/message.dart';

class ChatList extends ConsumerStatefulWidget {
  static const routename = '/mobile_chat_screen';
  final bool isGroupChat;
  final String recieverUserId;
  const ChatList(
      {required this.isGroupChat, required this.recieverUserId, super.key});

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageScrollController = ScrollController();
  @override
  void dispose() {
    super.dispose();
    messageScrollController.dispose();
  }

  onMessageSwipe(
      {required String message,
      required bool isMe,
      required MessageEnum messageEnum}) {
    ref.read(messageReplyProvider.notifier).update((state) =>
        MessageReply(message: message, isMe: isMe, messageEnum: messageEnum));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: widget.isGroupChat
            ? ref
                .read(chatControllerProvider)
                .getGroupChatStream(widget.recieverUserId)
            : ref
                .read(chatControllerProvider)
                .getChatStream(widget.recieverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          if (snapshot.data == null) return const Text('start a chat');
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            messageScrollController
                .jumpTo(messageScrollController.position.maxScrollExtent);
          });

          return ListView.builder(
              controller: messageScrollController,
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var message = snapshot.data![index];
                if (message.isSeen == false &&
                    message.recieverId ==
                        ref
                            .read(authRepositoryProvider)
                            .auth
                            .currentUser!
                            .uid) {
                  ref.read(chatControllerProvider).setChatMessageSeen(
                      context: context,
                      recieverUserId: widget.recieverUserId,
                      messageId: message.messageId);
                }
                return message.senderId ==
                        ref.read(authRepositoryProvider).auth.currentUser!.uid
                    ? MyMessageCard(
                        message: message.text,
                        date: DateFormat.Hm().format(message.timeSent),
                        type: message.type,
                        onLeftSwipe: () {
                          onMessageSwipe(
                              message: message.text,
                              isMe: true,
                              messageEnum: message.type);
                        },
                        repliedText: message.repliedText,
                        username: message.userName,
                        repliedMessageType: message.repliedMessageType,
                        isSeen: message.isSeen)
                    : SenderMessageCard(
                        message: message.text,
                        date: DateFormat.Hm().format(message.timeSent),
                        type: message.type,
                        onRightSwipe: () {
                          onMessageSwipe(
                              message: message.text,
                              isMe: false,
                              messageEnum: message.type);
                        },
                        repliedText: '',
                        username: message.senderId,
                        repliedMessageType: message.repliedMessageType,
                        isSeen: message.isSeen);
              });
        });
  }
}
