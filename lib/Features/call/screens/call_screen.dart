// ignore_for_file: use_build_context_synchronously

import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Common/config/agora_config.dart';
import 'package:whatsapp_clone/Common/widgets/loader.dart';
import 'package:whatsapp_clone/Features/call/controller/call_controller.dart';
import 'package:whatsapp_clone/Models/call.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final Call call;
  final bool isGroupChat;
  const CallScreen(
      {required this.channelId,
      required this.call,
      required this.isGroupChat,
      super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  AgoraClient? client;
  String baseUrl = 'https://whatsapp-clone-server-gtnt.onrender.com';
  @override
  void initState() {
    super.initState();
    client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
            appId: AgoraConfig.appId,
            channelName: widget.channelId,
            tokenUrl: baseUrl));
    initAgora();
  }

  void endCall(
      {required String callerId,
      required String recieverId,
      required BuildContext context}) async {
    ref.read(callControllerProvider).endCall(
        callerId: callerId,
        recieverId: recieverId,
        context: context,
        isGroupChat: widget.isGroupChat);
  }

  Future<void> initAgora() async {
    await client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: client == null
          ? const Loader()
          : SafeArea(
              child: Stack(
              children: [
                AgoraVideoViewer(client: client!),
                AgoraVideoButtons(
                  client: client!,
                  disconnectButtonChild: IconButton(
                      onPressed: () async {
                        await client!.engine.leaveChannel();
                        endCall(
                            callerId: widget.call.callerId,
                            context: context,
                            recieverId: widget.call.recieverId);
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.call_end,
                        color: Colors.red,
                      )),
                )
              ],
            )),
    );
  }
}
