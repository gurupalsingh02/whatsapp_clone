import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Common/widgets/utils/utils.dart';
import 'package:whatsapp_clone/Models/call.dart';

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
    } catch (e) {
      showSnakBar(context, e.toString());
    }
  }
}
