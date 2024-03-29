import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/Common/widgets/Repositories/common_firebase_storage_repository.dart';
import 'package:whatsapp_clone/Common/widgets/utils/utils.dart';
import 'package:whatsapp_clone/Models/status_model.dart';
import 'package:whatsapp_clone/Models/user_model.dart';

final statusRepositoryProvider = Provider((ref) => StatusRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref));

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  StatusRepository(
      {required this.firestore, required this.auth, required this.ref});
  void uploadStatus(
      {required String userName,
      required String phoneNumber,
      required String profilePic,
      required File statusImage,
      required BuildContext context}) async {
    try {
      var statusId = Uuid().v1();
      String uid = auth.currentUser!.uid;
      String imageUrl = await ref
          .read(commonFireBaseStorageRepositoryProvider)
          .storeFileToFirebase('status/$statusId', statusImage);
      List<Contact> contacts = [];

      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      List<String> whoCanSee = [];
      for (int i = 0; i < contacts.length; i++) {
        var userDataFirebase = await firestore
            .collection('users')
            .where('phoneNumber',
                isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''))
            .get();
        if (userDataFirebase.docs.isNotEmpty) {
          var userData = UserModel.fromMap(userDataFirebase.docs[0].data());
          whoCanSee.add(userData.uid);
        }
      }
      List<String> statusImageUrls = [];
      var statusesSnapshot = await firestore
          .collection('status')
          .where('uid', isEqualTo: auth.currentUser!.uid)
          .where('createdAt',
              isGreaterThan: DateTime.now().subtract(const Duration(hours: 24)))
          .get();
      if (statusesSnapshot.docs.isNotEmpty) {
        Status status = Status.fromMap(statusesSnapshot.docs[0].data());
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageUrl);
        await firestore
            .collection('status')
            .doc(statusesSnapshot.docs[0].id)
            .update({'photoUrl': statusImageUrls});
      } else {
        statusImageUrls = [imageUrl];
        Status status = Status(
            uid: uid,
            userName: userName,
            phoneNumber: phoneNumber,
            photoUrl: statusImageUrls,
            createdAt: DateTime.now(),
            profilePic: profilePic,
            statusId: statusId,
            whoCanSee: whoCanSee);
        await firestore.collection('status').doc(statusId).set(status.toMap());
      }
    } catch (e) {
      showSnakBar(context, e.toString());
    }
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statusData = [];
    try {
      List<Contact> contacts = [];

      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      for (int i = 0; i < contacts.length; i++) {
        var statusesSnapshot = await firestore
            .collection('status')
            .where('phoneNumber',
                isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''))
            .where('createdAt',
                isGreaterThan: DateTime.now()
                    .subtract(const Duration(hours: 24))
                    .millisecondsSinceEpoch)
            .get();
        for (var tempData in statusesSnapshot.docs) {
          Status tempStatus = Status.fromMap(tempData.data());
          if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
            statusData.add(tempStatus);
          }
        }
      }
    } catch (e) {
      showSnakBar(context, e.toString());
    }
    return statusData;
  }
}
