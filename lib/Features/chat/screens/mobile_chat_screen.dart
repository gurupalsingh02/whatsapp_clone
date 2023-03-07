import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Common/widgets/loader.dart';
import 'package:whatsapp_clone/Features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/Features/chat/widgets/bottom_chat_field.dart';
import 'package:whatsapp_clone/Features/chat/widgets/chat_list.dart';
import 'package:whatsapp_clone/Models/user_model.dart';

class MobileChatScreen extends ConsumerWidget {
  static const routename = '/mobile_chat_screen';
  final String name;
  final String recieverUserId;
  const MobileChatScreen(
      {super.key, required this.name, required this.recieverUserId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<UserModel>(
          stream: ref.watch(authControllerProvider).userData(recieverUserId),
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
      ),
      body: Column(
        children: [
          ChatList(recieverUserId: recieverUserId),
          const Expanded(child: SizedBox()),
          BottomChatField(
            recieverUserId: recieverUserId,
          )
        ],
      ),
    );
  }
}
