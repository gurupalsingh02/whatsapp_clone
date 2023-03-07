import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/Common/enums/message_enum.dart';
import 'package:whatsapp_clone/Common/widgets/utils/utils.dart';
import 'package:whatsapp_clone/Models/chat_contact.dart';
import 'package:whatsapp_clone/Models/message.dart';
import 'package:whatsapp_clone/Models/user_model.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({required this.firestore, required this.auth});

  Stream<List<Message>> getChatStream(String recieverUserId) {
    // String id = Uuid().v4();
    // firestore
    //     .collection('users')
    //     .doc(auth.currentUser!.uid)
    //     .collection('chats')
    //     .doc(recieverUserId)
    //     .collection('messages')

    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .snapshots()
        .asyncMap((event) async {
      List<Message> messages = [];
      print('hi');
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

  Future<void> sendTextMessage(
      {required BuildContext context,
      required String text,
      required String recieverUserId,
      required UserModel senderUser}) async {
    try {
      var timeSent = DateTime.now();
      var snapshot =
          await firestore.collection('users').doc(recieverUserId).get();
      var messageId = const Uuid().v4();
      UserModel recieverUser = UserModel.fromMap(snapshot.data()!);
      _saveDataToContactSubCollection(
        senderUserData: senderUser,
        recieverUserData: recieverUser,
        text: text,
        timeSent: timeSent,
        messageId: messageId,
      );
      _saveMessageToMessageSubCollection(
          recieverUserId: recieverUserId,
          senderUserId: senderUser.uid,
          text: text,
          timeSent: timeSent,
          messageId: messageId,
          messageType: MessageEnum.text,
          recieverUserName: recieverUser.name,
          userName: senderUser.name);
    } catch (e) {
      showSnakBar(context, e.toString());
    }
  }

  _saveDataToContactSubCollection({
    required UserModel senderUserData,
    required UserModel recieverUserData,
    required String text,
    required DateTime timeSent,
    required String messageId,
  }) async {
    var recieverChatContact = ChatContact(
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        timeSent: timeSent,
        lastMessage: text);
    await firestore
        .collection('users')
        .doc(recieverUserData.uid)
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

  _saveMessageToMessageSubCollection({
    required String recieverUserId,
    required String senderUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required MessageEnum messageType,
    required String recieverUserName,
    required String userName,
  }) async {
    final message = Message(
        senderId: senderUserId,
        recieverId: recieverUserId,
        text: text,
        type: messageType,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false);
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
