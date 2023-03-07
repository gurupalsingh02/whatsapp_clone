import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whatsapp_clone/Features/chat/widgets/contacts_list.dart';

class MobileLayoutScreen extends ConsumerWidget {
  const MobileLayoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, SelectContactScreen.routename);
        },
        child: const Icon(Icons.comment),
      ),
      appBar: AppBar(
        title: const Text('WhatsApp'),
      ),
      body: const ContactList(),
    );
  }
}
