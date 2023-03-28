// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Common/widgets/utils/utils.dart';
import 'package:whatsapp_clone/Features/call/screens/call_screen.dart';
import 'package:whatsapp_clone/Models/call.dart';
import 'package:whatsapp_clone/Models/group.dart' as model;

final callRepositoryProvider = Provider((ref) => CallRepository(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class CallRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CallRepository({
    required this.firestore,
    required this.auth,
  });
  Stream<DocumentSnapshot> get callStream =>
      firestore.collection('call').doc(auth.currentUser!.uid).snapshots();

  void endCall(
      {required String callerId,
      required String recieverId,
      required BuildContext context}) async {
    try {
      await firestore.collection('call').doc(callerId).delete();
      await firestore.collection('call').doc(recieverId).delete();
    } catch (e) {
      showSnakBar(context, e.toString());
    }
  }

  void endGroupCall(
      {required String callerId,
      required String recieverId,
      required BuildContext context}) async {
    try {
      await firestore.collection('call').doc(callerId).delete();

      var groupData =
          await firestore.collection('groups').doc(recieverId).get();
      model.Group group = model.Group.fromMap(groupData.data()!);
      for (var id in group.membersUid) {
        if (id != auth.currentUser!.uid) {
          await firestore.collection('call').doc(id).delete();
        }
      }
    } catch (e) {
      showSnakBar(context, e.toString());
    }
  }

  void makeCall(
      {required Call senderCallData,
      required Call recieverCallData,
      required BuildContext context}) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      await firestore
          .collection('call')
          .doc(senderCallData.recieverId)
          .set(recieverCallData.toMap());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CallScreen(
                  channelId: senderCallData.callId,
                  call: senderCallData,
                  isGroupChat: false)));
    } catch (e) {
      showSnakBar(context, e.toString());
    }
  }

  void makeGroupCall(
      {required Call senderCallData,
      required Call recieverCallData,
      required BuildContext context}) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      var groupData = await firestore
          .collection('groups')
          .doc(senderCallData.recieverId)
          .get();
      model.Group group = model.Group.fromMap(groupData.data()!);
      for (var id in group.membersUid) {
        if (id != auth.currentUser!.uid) {
          await firestore
              .collection('call')
              .doc(id)
              .set(recieverCallData.toMap());
        }
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CallScreen(
                  channelId: senderCallData.callId,
                  call: senderCallData,
                  isGroupChat: true)));
    } catch (e) {
      showSnakBar(context, e.toString());
    }
  }
}
