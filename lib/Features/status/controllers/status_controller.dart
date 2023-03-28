import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/Features/auth/repositories/auth_repository.dart';
import 'package:whatsapp_clone/Features/status/repositories/status_repository.dart';
import 'package:whatsapp_clone/Models/status_model.dart';

final statusControllerProvider = Provider((ref) {
  final statusRepository = ref.read(statusRepositoryProvider);
  return StatusController(statusRepository: statusRepository, ref: ref);
});

class StatusController {
  final StatusRepository statusRepository;
  final ProviderRef ref;

  StatusController({required this.statusRepository, required this.ref});

  void addStatus({
    required File file,
    required BuildContext context,
  }) {
    ref.watch(userDataAuthProvider).whenData((value) {
      statusRepository.uploadStatus(
          userName: value!.name,
          phoneNumber: value.phoneNumber,
          profilePic: value.profilePic,
          statusImage: file,
          context: context);
    });
  }

  Future<List<Status>> getStatus(BuildContext context) {
    return statusRepository.getStatus(context);
  }
}
