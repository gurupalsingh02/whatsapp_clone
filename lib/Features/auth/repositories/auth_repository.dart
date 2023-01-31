// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Common/widgets/utils/utils.dart';
import 'package:whatsapp_clone/Features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/Features/auth/screens/user_infromation_screen.dart';
import 'package:whatsapp_clone/router.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});
  void SignInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (exception) {},
          codeSent: (String verificationId, int? forceResendingToken) {
            Navigator.pushNamed(context, OTPScreen.routename,
                arguments: verificationId);
          },
          codeAutoRetrievalTimeout: (String temp) {});
    } on FirebaseAuthException catch (error) {
      showSnakBar(context, error.message.toString());
    }
  }

  void verifyOTP(
      BuildContext context, String verificationID, String userOTP) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationID, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
          context, UserScreen.routename, (route) => false);
    } on FirebaseAuthException catch (error) {
      showSnakBar(context, 'otp is not correct');
    }
  }
}
