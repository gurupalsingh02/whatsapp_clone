// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Common/widgets/utils/utils.dart';
import 'package:whatsapp_clone/Models/user_model.dart';
import 'package:whatsapp_clone/Features/chat/screens/mobile_chat_screen.dart';

final selectContactRepositoryProvider = Provider(
    (ref) => SelectContactRepository(firestore: FirebaseFirestore.instance));

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({required this.firestore});

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {}
    return contacts;
  }

  selectContact(
      {required Contact selectedContact, required BuildContext context}) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;
      String selectedPhoneNumber =
          selectedContact.phones[0].number.replaceAll(' ', '');
      for (var doc in userCollection.docs) {
        var userData = UserModel.fromMap(doc.data());
        if (selectedPhoneNumber == userData.phoneNumber) {
          isFound = true;
          Navigator.pushNamed(context, MobileChatScreen.routename, arguments: {
            'name': userData.name,
            'recieverUserId': userData.uid,
          });
        }
      }
      if (!isFound) {
        showSnakBar(context, 'this Number does not exist on this app');
      }
    } catch (e) {
      print('error');
    }
  }
}
