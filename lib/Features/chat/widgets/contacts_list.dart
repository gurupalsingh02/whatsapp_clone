import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/Common/widgets/loader.dart';
import 'package:whatsapp_clone/Features/chat/controllers/chat_controller.dart';
import 'package:whatsapp_clone/Features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_clone/Models/chat_contact.dart';
import 'package:whatsapp_clone/Models/group.dart';

class ContactList extends ConsumerWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<List<Group>>(
            stream: ref.read(chatControllerProvider).getChatGroups(),
            builder: (context, snapshot) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data == null ? 0 : snapshot.data!.length,
                  itemBuilder: (context, index) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loader();
                    }
                    var groupdata = snapshot.data![index];
                    return Column(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  MobileChatScreen.routename,
                                  arguments: {
                                    'name': groupdata.name,
                                    'recieverUserId': groupdata.groupId,
                                    'isGroupChat': true,
                                    'profilePic': groupdata.groupPic
                                  });
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(groupdata.groupPic)),
                              title: Text(groupdata.name),
                              subtitle: Text(groupdata.lastMessage),
                              trailing: Text(
                                  DateFormat.Hm().format(groupdata.timeSent)),
                            )),
                      ],
                    );
                  });
            },
          ),
          StreamBuilder<List<ChatContact>>(
            stream: ref.read(chatControllerProvider).getChatContacts(),
            builder: (context, snapshot) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data == null ? 0 : snapshot.data!.length,
                  itemBuilder: (context, index) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loader();
                    }
                    return Column(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  MobileChatScreen.routename,
                                  arguments: {
                                    'name': snapshot.data![index].name,
                                    'recieverUserId':
                                        snapshot.data![index].contactId,
                                    'isGroupChat': false,
                                    'profilePic':
                                        snapshot.data![index].profilePic
                                  });
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      snapshot.data![index].profilePic)),
                              title: Text(snapshot.data![index].name),
                              subtitle: Text(snapshot.data![index].lastMessage),
                              trailing: Text(DateFormat.Hm()
                                  .format(snapshot.data![index].timeSent)),
                            )),
                      ],
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}
