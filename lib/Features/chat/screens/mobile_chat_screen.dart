import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Common/widgets/loader.dart';
import 'package:whatsapp_clone/Features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/Features/call/controller/call_controller.dart';
import 'package:whatsapp_clone/Features/call/screens/call_pickup_screen.dart';
import 'package:whatsapp_clone/Features/chat/widgets/bottom_chat_field.dart';
import 'package:whatsapp_clone/Features/chat/widgets/chat_list.dart';
import 'package:whatsapp_clone/Models/user_model.dart';

class MobileChatScreen extends ConsumerWidget {
  static const routename = '/mobile_chat_screen';
  final bool isGroupChat;
  final String name;
  final String recieverUserId;
  final String profilePic;
  const MobileChatScreen(
      {required this.profilePic,
      required this.isGroupChat,
      super.key,
      required this.name,
      required this.recieverUserId});

  void makeCall(
    WidgetRef ref,
    BuildContext context,
  ) {
    ref.read(callControllerProvider).makeCall(
        context: context,
        recieverName: name,
        recieverId: recieverUserId,
        recieverProfilePic: profilePic,
        isGroupChat: isGroupChat);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CallPickupScreen(
      scaffold: Scaffold(
        appBar: AppBar(
          title: isGroupChat
              ? Text(name)
              : StreamBuilder<UserModel>(
                  stream:
                      ref.read(authControllerProvider).userData(recieverUserId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loader();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name),
                        Text(
                          snapshot.data!.isOnline ? 'Online' : 'Offline',
                          style: const TextStyle(fontSize: 14),
                        )
                      ],
                    );
                  },
                ),
          actions: [
            IconButton(
                onPressed: () {
                  makeCall(ref, context);
                },
                icon: const Icon(Icons.video_call)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.call))
          ],
        ),
        body: isGroupChat
            ? Column(
                children: [
                  Expanded(
                      child: ChatList(
                    recieverUserId: recieverUserId,
                    isGroupChat: true,
                  )),
                  BottomChatField(
                    recieverUserId: recieverUserId,
                    isGroupChat: true,
                  ),
                ],
              )
            : Column(
                children: [
                  Expanded(
                      child: ChatList(
                    recieverUserId: recieverUserId,
                    isGroupChat: false,
                  )),
                  BottomChatField(
                    recieverUserId: recieverUserId,
                    isGroupChat: false,
                  ),
                ],
              ),
      ),
    );
  }
}
