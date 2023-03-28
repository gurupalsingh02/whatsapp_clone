// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_clone/Features/select_contacts/repositories/select_contact_repository.dart';

final getContactsProvider = FutureProvider((ref) {
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return selectContactRepository.getContacts();
});
final selectContactControllerProvider = Provider((ref) {
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return SelectContactController(
      selectContactRepository: selectContactRepository, ref: ref);
});

class SelectContactController {
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;
  SelectContactController({
    required this.selectContactRepository,
    required this.ref,
  });
  selectContact(Contact selectedContact, BuildContext context) {
    selectContactRepository.selectContact(
        selectedContact: selectedContact, context: context);
  }
}
