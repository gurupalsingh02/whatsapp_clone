import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Features/group/repository/group_repository.dart';

final groupControllerProvider = Provider((ref) {
  final groupRepository = ref.read(groupRepositoryProvider);
  return GroupController(
    groupRepository: groupRepository,
    ref: ref,
  );
});

class GroupController {
  final GroupRepository groupRepository;
  final ProviderRef ref;

  GroupController({
    required this.groupRepository,
    required this.ref,
  });

  void createGroup(
      {required BuildContext context,
      required String name,
      required File profilePic,
      required List<Contact> selectedContact}) {
    groupRepository.createGroup(
        context: context,
        name: name,
        profilePic: profilePic,
        selectedContact: selectedContact);
  }
}
