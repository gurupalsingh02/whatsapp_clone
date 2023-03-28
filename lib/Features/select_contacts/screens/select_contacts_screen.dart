import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Common/widgets/error.dart';
import 'package:whatsapp_clone/Common/widgets/loader.dart';
import 'package:whatsapp_clone/Features/select_contacts/controller/select_contact_controller.dart';

class SelectContactScreen extends ConsumerWidget {
  static const routename = '/select_contacts';
  const SelectContactScreen({super.key});

  selectContact(Contact contact, BuildContext context, WidgetRef ref) {
    final selectContactController = ref.read(selectContactControllerProvider);
    selectContactController.selectContact(contact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Contacts'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: ref.watch(getContactsProvider).when(
          data: (contactsList) {
            return ListView.builder(
                itemCount: contactsList.length,
                itemBuilder: (context, index) {
                  final contact = contactsList[index];
                  return InkWell(
                    onTap: () {
                      selectContact(contact, context, ref);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ListTile(
                        title: Text(contact.displayName),
                        leading: contact.photo == null
                            ? null
                            : CircleAvatar(
                                radius: 20,
                                backgroundImage: MemoryImage(contact.photo!),
                              ),
                      ),
                    ),
                  );
                });
          },
          error: (error, trace) {
            ErrorScreen(error: error.toString());
          },
          loading: () => const Loader()),
    );
  }
}
