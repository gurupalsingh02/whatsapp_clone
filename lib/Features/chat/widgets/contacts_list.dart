import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/Common/widgets/loader.dart';
import 'package:whatsapp_clone/Features/chat/controllers/chat_controller.dart';
import 'package:whatsapp_clone/Features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_clone/Models/chat_contact.dart';

class ContactList extends ConsumerWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<ChatContact>>(
      stream: ref.watch(chatControllerProvider).getChatContacts(),
      builder: (context, snapshot) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }
              return Column(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(MobileChatScreen.routename, arguments: {
                          'name': snapshot.data![index].name,
                          'recieverUserId': snapshot.data![index].contactId
                        });
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(snapshot.data![index].profilePic)),
                        title: Text(snapshot.data![index].name),
                        subtitle: Text(snapshot.data![index].lastMessage),
                        trailing: Text(DateFormat.Hm()
                            .format(snapshot.data![index].timeSent)),
                      )),
                ],
              );
            });
      },
    );
  }
}
