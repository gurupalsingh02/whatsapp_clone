import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/Common/enums/message_enum.dart';
import 'package:whatsapp_clone/Common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/Common/widgets/Repositories/common_firebase_storage_repository.dart';
import 'package:whatsapp_clone/Common/widgets/utils/utils.dart';
import 'package:whatsapp_clone/Models/chat_contact.dart';
import 'package:whatsapp_clone/Models/group.dart';
import 'package:whatsapp_clone/Models/message.dart';
import 'package:whatsapp_clone/Models/user_model.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({required this.firestore, required this.auth});

  Stream<List<Message>> getChatStream(String recieverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  Stream<List<Message>> getGroupChatStream(String groupId) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> chatContacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);
        chatContacts.add(ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage));
      }
      return chatContacts;
    });
  }

  Future<void> sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String recieverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      var snapshot =
          await firestore.collection('users').doc(recieverUserId).get();
      var messageId = const Uuid().v1();

      UserModel? recieverUser;
      if (!isGroupChat) {
        var snapshot =
            await firestore.collection('users').doc(recieverUserId).get();
        recieverUser = UserModel.fromMap(snapshot.data()!);
      }
      _saveDataToContactSubCollection(
        senderUserData: senderUser,
        recieverUserData: recieverUser,
        text: 'GIF',
        timeSent: timeSent,
        recieverUserId: recieverUserId,
        isGroupChat: isGroupChat,
      );
      _saveMessageToMessageSubCollection(
        recieverUserId: recieverUserId,
        senderUserId: senderUser.uid,
        text: gifUrl,
        timeSent: timeSent,
        messageId: messageId,
        messageType: MessageEnum.gif,
        recieverUserName: recieverUser == null ? '' : recieverUser.name,
        senderUserName: senderUser.name,
        messageReply: messageReply,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      showSnakBar(context, e.toString());
    }
  }

  Future<void> sendTextMessage(
      {required BuildContext context,
      required String text,
      required String recieverUserId,
      required UserModel senderUser,
      required MessageReply? messageReply,
      required bool isGroupChat}) async {
    try {
      var timeSent = DateTime.now();
      UserModel? recieverUser;
      if (!isGroupChat) {
        var snapshot =
            await firestore.collection('users').doc(recieverUserId).get();
        recieverUser = UserModel.fromMap(snapshot.data()!);
      }
      var messageId = const Uuid().v1();
      _saveDataToContactSubCollection(
          senderUserData: senderUser,
          recieverUserData: recieverUser,
          text: text,
          timeSent: timeSent,
          recieverUserId: recieverUserId,
          isGroupChat: isGroupChat);
      _saveMessageToMessageSubCollection(
        recieverUserId: recieverUserId,
        senderUserId: senderUser.uid,
        text: text,
        timeSent: timeSent,
        messageId: messageId,
        messageType: MessageEnum.text,
        recieverUserName: recieverUser == null ? '' : recieverUser.name,
        senderUserName: senderUser.name,
        messageReply: messageReply,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      showSnakBar(context, e.toString());
    }
  }

  _saveDataToContactSubCollection(
      {required UserModel senderUserData,
      required UserModel? recieverUserData,
      required String text,
      required String recieverUserId,
      required DateTime timeSent,
      required bool isGroupChat}) async {
    if (isGroupChat) {
      await firestore.collection('groups').doc(recieverUserId).update({
        'lastMessage': text,
        'timeSent': DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      var recieverChatContact = ChatContact(
          name: senderUserData.name,
          profilePic: senderUserData.profilePic,
          contactId: senderUserData.uid,
          timeSent: timeSent,
          lastMessage: text);
      await firestore
          .collection('users')
          .doc(recieverUserData!.uid)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .set(recieverChatContact.toMap());
      var senderChatContact = ChatContact(
          name: recieverUserData.name,
          profilePic: recieverUserData.profilePic,
          contactId: recieverUserData.uid,
          timeSent: timeSent,
          lastMessage: text);
      await firestore
          .collection('users')
          .doc(senderUserData.uid)
          .collection('chats')
          .doc(recieverUserData.uid)
          .set(senderChatContact.toMap());
    }
  }

  _saveMessageToMessageSubCollection({
    required String recieverUserId,
    required String senderUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required MessageEnum messageType,
    required String? recieverUserName,
    required String senderUserName,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    final message = Message(
        senderId: senderUserId,
        recieverId: recieverUserId,
        text: text,
        type: messageType,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false,
        repliedMessageType:
            messageReply == null ? MessageEnum.text : messageReply.messageEnum,
        repliedText: messageReply == null ? '' : messageReply.message,
        repliedTo: messageReply == null
            ? ''
            : messageReply.isMe
                ? senderUserName
                : recieverUserName ?? '',
        userName: senderUserName);
    if (isGroupChat) {
      await firestore
          .collection('groups')
          .doc(recieverUserId)
          .collection('chats')
          .doc(messageId)
          .set(message.toMap());
    } else {
      firestore
          .collection('users')
          .doc(senderUserId)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());
      firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(senderUserId)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());
    }
  }

  void sendFileMessage(
      {required BuildContext context,
      required File file,
      required String recieverUserId,
      required UserModel senderUserData,
      required ProviderRef ref,
      required MessageEnum messageEnum,
      required MessageReply? messageReply,
      required bool isGroupChat}) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String fileurl = await ref
          .read(commonFireBaseStorageRepositoryProvider)
          .storeFileToFirebase(
              'chat/${messageEnum.type}/${senderUserData.uid}/$recieverUserId/$messageId',
              file);

      UserModel? recieverUserData;
      if (!isGroupChat) {
        var snapshot =
            await firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserModel.fromMap(snapshot.data()!);
      }
      String contactMsg;
      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷Photo';
          break;
        case MessageEnum.video:
          contactMsg = '📸Video';
          break;
        case MessageEnum.audio:
          contactMsg = '🎵Audio';
          break;
        case MessageEnum.gif:
          contactMsg = 'gif';
          break;
        default:
          contactMsg = 'gif';
      }
      _saveDataToContactSubCollection(
        senderUserData: senderUserData,
        recieverUserData: recieverUserData,
        text: contactMsg,
        timeSent: timeSent,
        isGroupChat: isGroupChat,
        recieverUserId: recieverUserId,
      );
      _saveMessageToMessageSubCollection(
          recieverUserId: recieverUserId,
          senderUserId: senderUserData.uid,
          text: fileurl,
          timeSent: timeSent,
          messageId: messageId,
          messageType: messageEnum,
          recieverUserName:
              recieverUserData == null ? '' : recieverUserData.name,
          senderUserName: senderUserData.name,
          messageReply: messageReply,
          isGroupChat: isGroupChat);
    } catch (e) {
      showSnakBar(context, e.toString());
    }
  }

  void setChatMessageSeen(
      {required BuildContext context,
      required String recieverUserId,
      required String messageId}) {
    try {
      firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
      firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      print('seen');
    } catch (e) {
      showSnakBar(context, e.toString());
    }
  }

  Stream<List<Group>> getChatGroups() {
    return firestore.collection('groups').snapshots().map((event) {
      List<Group> groups = [];
      for (var document in event.docs) {
        var group = Group.fromMap(document.data());
        if (group.membersUid.contains(auth.currentUser!.uid)) {
          groups.add(group);
        }
      }
      return groups;
    });
  }
}
