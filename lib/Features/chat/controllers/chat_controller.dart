import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Common/enums/message_enum.dart';
import 'package:whatsapp_clone/Common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/Features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/Features/chat/repositories/chat_repository.dart';
import 'package:whatsapp_clone/Models/chat_contact.dart';
import 'package:whatsapp_clone/Models/group.dart';
import 'package:whatsapp_clone/Models/message.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  Stream<List<ChatContact>> getChatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Group>> getChatGroups() {
    return chatRepository.getChatGroups();
  }

  Stream<List<Message>> getGroupChatStream(String groupId) {
    return chatRepository.getGroupChatStream(groupId);
  }

  void sendTextMessage(
      {required BuildContext context,
      required String text,
      required String recieverUserId,
      required bool isGroupChat}) async {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData((senderUser) =>
        chatRepository.sendTextMessage(
            context: context,
            text: text,
            recieverUserId: recieverUserId,
            senderUser: senderUser!,
            messageReply: messageReply,
            isGroupChat: isGroupChat));
  }

  void sendGIFMessage(
      {required BuildContext context,
      required String gifUrl,
      required String recieverUserId,
      required bool isGroupChat}) async {
    final messageReply = ref.read(messageReplyProvider);
    String GifUrlPart = 'https://i.giphy.com/media/';
    int importantUrlIndex = gifUrl.lastIndexOf('-') + 1;
    String importantGifUrl = gifUrl.substring(importantUrlIndex);
    gifUrl = '$GifUrlPart$importantGifUrl/200.gif';
    ref
        .read(userDataAuthProvider)
        .whenData((senderUser) => chatRepository.sendGIFMessage(
              context: context,
              gifUrl: gifUrl,
              recieverUserId: recieverUserId,
              senderUser: senderUser!,
              messageReply: messageReply,
              isGroupChat: isGroupChat,
            ));
  }

  void sendFileMessage(
      {required BuildContext context,
      required File file,
      required String recieverUserId,
      required MessageEnum messageEnum,
      required bool isGroupChat}) async {
    final messageReply = ref.read(messageReplyProvider);
    ref
        .read(userDataAuthProvider)
        .whenData((senderUser) => chatRepository.sendFileMessage(
              context: context,
              recieverUserId: recieverUserId,
              file: file,
              messageEnum: messageEnum,
              ref: ref,
              senderUserData: senderUser!,
              messageReply: messageReply,
              isGroupChat: isGroupChat,
            ));
  }

  Stream<List<Message>> getChatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  void setChatMessageSeen({
    required BuildContext context,
    required String recieverUserId,
    required String messageId,
  }) {
    chatRepository.setChatMessageSeen(
        context: context, recieverUserId: recieverUserId, messageId: messageId);
  }
}
