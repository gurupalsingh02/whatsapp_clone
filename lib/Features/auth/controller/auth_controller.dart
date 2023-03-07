// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Features/auth/repositories/auth_repository.dart';
import 'package:whatsapp_clone/Models/user_model.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});
final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getCurrentUserData();
});

class AuthController {
  final ProviderRef ref;
  final AuthRepository authRepository;

  AuthController({required this.ref, required this.authRepository});
  void SignInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.SignInWithPhone(context, phoneNumber);
  }

  Future<UserModel?> getCurrentUserData() async {
    return authRepository.getCurrentUserData();
  }

  void verifyOTP(BuildContext context, String verificationID, String userOTP) {
    authRepository.verifyOTP(context, verificationID, userOTP);
  }

  void saveUserDataToFirebase(
      {required String name,
      required File? profilePic,
      required BuildContext context}) {
    authRepository.saveUserDataToFireBase(
        name: name, profilePic: profilePic, ref: ref, context: context);
  }

  Stream<UserModel> userData(String uid) {
    return authRepository.userData(uid);
  }
}
