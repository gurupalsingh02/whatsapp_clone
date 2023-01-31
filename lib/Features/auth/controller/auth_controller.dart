// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Features/auth/repositories/auth_repository.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository);
});

class AuthController {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});
  void SignInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.SignInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context, String verificationID, String userOTP) {
    authRepository.verifyOTP(context, verificationID, userOTP);
  }
}
