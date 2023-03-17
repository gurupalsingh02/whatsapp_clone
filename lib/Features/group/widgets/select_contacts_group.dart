import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Common/widgets/error.dart';
import 'package:whatsapp_clone/Common/widgets/loader.dart';
import 'package:whatsapp_clone/Features/select_contacts/controller/select_contact_controller.dart';

final selectedGroupContactsProvider = StateProvider<List<Contact>>((ref) => []);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({super.key});

  @override
  ConsumerState<SelectContactsGroup> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectedContactIndex = [];
  void selectContact(int index, Contact contact) {
    if (selectedContactIndex.contains(index)) {
      selectedContactIndex.remove(index);
    } else {
      selectedContactIndex.add(index);
    }
    setState(() {});
    ref.read(selectedGroupContactsProvider.notifier).update((state) {
      if (state.contains(contact)) {
        state.remove(contact);
      } else {
        state.add(contact);
      }
      return state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider).when(data: (data) {
      return Expanded(
        child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final contact = data[index];
              return InkWell(
                onTap: () => selectContact(index, contact),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: selectedContactIndex.contains(index)
                        ? const Icon(Icons.done)
                        : null,
                    title: Text(
                      contact.displayName,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              );
            }),
      );
    }, error: (error, stacktrace) {
      return ErrorScreen(error: error.toString());
    }, loading: () {
      return const Loader();
    });
  }
}
