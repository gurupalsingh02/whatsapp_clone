// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Common/widgets/utils/utils.dart';
import 'package:whatsapp_clone/Features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/Features/group/screens/create_group_screen.dart';
import 'package:whatsapp_clone/Features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whatsapp_clone/Features/chat/widgets/contacts_list.dart';
import 'package:whatsapp_clone/Features/status/screens/confirm_status_screen.dart';
import 'package:whatsapp_clone/Features/status/screens/status_contacts_screen.dart';
import 'package:whatsapp_clone/Common/widgets/utils/colors.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({super.key});

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    tabController.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        setUserState(true);
        break;
      case AppLifecycleState.inactive:
        setUserState(false);
        break;
      case AppLifecycleState.paused:
        setUserState(false);
        break;
      case AppLifecycleState.detached:
        setUserState(false);
        break;
    }
  }

  void setUserState(bool isOnline) {
    ref.read(authControllerProvider).setUserState(isOnline);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (tabController.index == 0) {
            Navigator.pushNamed(context, SelectContactScreen.routename);
          } else if (tabController.index == 1) {
            try {
              File? pickedImage = await pickImageFromGallery(context);
              if (pickedImage != null) {
                Navigator.pushNamed(context, ConfirmStatusScreen.routename,
                    arguments: {'pickedImage': pickedImage});
              }
            } catch (e) {
              showSnakBar(context, e.toString());
            }
          }
        },
        child: tabController.index == 0
            ? const Icon(Icons.comment)
            : tabController.index == 1
                ? const Icon(Icons.camera_alt)
                : const Icon(Icons.abc),
      ),
      appBar: AppBar(
        title: const Text(
          'WhatsApp',
          style: TextStyle(color: greyColor),
        ),
        bottom: TabBar(
            controller: tabController,
            indicatorColor: tabColor,
            indicatorWeight: 4,
            unselectedLabelColor: greyColor,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            labelColor: tabColor,
            tabs: const [Text('chat'), Text('status'), Text('calls')]),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          PopupMenuButton(
              color: greyColor,
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('Create Group'),
                      onTap: () => Future(() => Navigator.pushNamed(
                          context, CreateGroupScreen.routename)),
                    )
                  ]),
        ],
      ),
      body: TabBarView(controller: tabController, children: const [
        ContactList(),
        StatusContactsScreen(),
        Text('calls')
      ]),
    );
  }
}
