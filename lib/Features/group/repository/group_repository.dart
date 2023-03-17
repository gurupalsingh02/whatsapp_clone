import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/Common/widgets/Repositories/common_firebase_storage_repository.dart';
import 'package:whatsapp_clone/Common/widgets/utils/utils.dart';
import 'package:whatsapp_clone/Models/group.dart' as model;

final groupRepositoryProvider = Provider((ref) => GroupRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref));

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  GroupRepository(
      {required this.firestore, required this.auth, required this.ref});

  void createGroup(
      {required BuildContext context,
      required String name,
      required File profilePic,
      required List<Contact> selectedContact}) async {
    try {
      List<String> uids = [];
      for (int i = 0; i < selectedContact.length; i++) {
        var userCollection = await firestore
            .collection('users')
            .where('phoneNumber',
                isEqualTo:
                    selectedContact[i].phones[0].number.replaceAll(' ', ''))
            .get();
        if (userCollection.docs[0].exists) {
          uids.add(userCollection.docs[0].data()['uid']);
        }
      }
      var groupId = const Uuid().v1();
      String profileUrl = await ref
          .read(commonFireBaseStorageRepositoryProvider)
          .storeFileToFirebase('groups/$groupId', profilePic);

      if (!uids.contains(auth.currentUser!.uid)) {
        uids = [auth.currentUser!.uid, ...uids];
      }
      model.Group group = model.Group(
          name: name,
          groupId: groupId,
          lastMessage: '',
          groupPic: profileUrl,
          membersUid: uids,
          timeSent: DateTime.now());
      await firestore.collection('groups').doc(groupId).set(group.toMap());
    } catch (e) {
      showSnakBar(context, e.toString());
    }
  }
}
