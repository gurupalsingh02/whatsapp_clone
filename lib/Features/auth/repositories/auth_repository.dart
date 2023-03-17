// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Common/widgets/Repositories/common_firebase_storage_repository.dart';
import 'package:whatsapp_clone/Common/widgets/utils/utils.dart';
import 'package:whatsapp_clone/Features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/Features/auth/screens/user_infromation_screen.dart';
import 'package:whatsapp_clone/Models/user_model.dart';
import 'package:whatsapp_clone/screens/mobile_layout_screen.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser!.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

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

  saveUserDataToFireBase(
      {required String name,
      required File? profilePic,
      required ProviderRef ref,
      required BuildContext context}) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl = defaultPhotoUrl;
      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFireBaseStorageRepositoryProvider)
            .storeFileToFirebase('/profilePic/$uid', profilePic);
      }
      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber!,
          groupId: []);
      await firestore.collection('users').doc(uid).set(user.toMap());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MobileLayoutScreen()),
          (route) => false);
    } catch (e) {}
  }

  Stream<UserModel> userData(String uid) {
    return firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }

  void setUserState(bool isOnline) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'isOnline': isOnline});
  }
}
