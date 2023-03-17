import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/Features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/Features/call/repository/call_repository.dart';
import 'package:whatsapp_clone/Models/call.dart';

final callControllerProvider = Provider((ref) {
  final callRepository = ref.read(callRepositoryProvider);
  return CallController(
      auth: callRepository.auth, callRepository: callRepository, ref: ref);
});

class CallController {
  final CallRepository callRepository;
  final ProviderRef ref;
  final FirebaseAuth auth;

  CallController(
      {required this.auth, required this.callRepository, required this.ref});
  Stream<DocumentSnapshot> get callSteam =>
      ref.read(callRepositoryProvider).callStream;
  void makeCall({
    required BuildContext context,
    required String recieverName,
    required String recieverId,
    required String recieverProfilePic,
    required bool isGroupChat,
  }) {
    ref.read(userDataAuthProvider).whenData((value) {
      String callId = const Uuid().v1();

      Call senderCallData = Call(
          callId: callId,
          hasDialled: true,
          callerId: value!.uid,
          callerName: value.name,
          callerPic: value.profilePic,
          recieverId: recieverId,
          recieverName: recieverName,
          recieverPic: recieverProfilePic);

      Call recieverCallData = Call(
          callId: callId,
          hasDialled: false,
          callerId: recieverId,
          callerName: recieverName,
          callerPic: recieverProfilePic,
          recieverId: value.uid,
          recieverName: value.name,
          recieverPic: value.profilePic);

      callRepository.makeCall(
          senderCallData: senderCallData,
          recieverCallData: recieverCallData,
          context: context);
    });
  }
}
