import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_clone/Common/enums/message_enum.dart';
import 'package:whatsapp_clone/Common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/Common/widgets/utils/utils.dart';
import 'package:whatsapp_clone/Features/chat/controllers/chat_controller.dart';
import 'package:whatsapp_clone/Features/chat/widgets/message_reply_preview.dart';
import 'package:whatsapp_clone/Common/widgets/utils/colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final bool isGroupChat;
  final String recieverUserId;
  const BottomChatField(
      {required this.isGroupChat, required this.recieverUserId, super.key});

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  final _messageController = TextEditingController();
  bool showSendButton = false;
  bool showEmojiPicker = false;
  FocusNode focusNode = FocusNode();
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isRecording = false;

  sendTextMessage() async {
    if (showSendButton) {
      final messageReply = ref.read(messageReplyProvider);
      if (_messageController.text.isNotEmpty) {
        ref.read(chatControllerProvider).sendTextMessage(
              context: context,
              text: _messageController.text,
              recieverUserId: widget.recieverUserId,
              isGroupChat: widget.isGroupChat,
            );
        _messageController.text = '';
      } else {
        showSnakBar(context, "can't send empty message");
      }
    } else {
      if (!isRecorderInit) return;
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(file: File(path), messageEnum: MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(toFile: path);
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage({required File file, required MessageEnum messageEnum}) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(chatControllerProvider).sendFileMessage(
        context: context,
        file: file,
        recieverUserId: widget.recieverUserId,
        messageEnum: messageEnum,
        isGroupChat: widget.isGroupChat);
  }

  void selectImage(BuildContext context) async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(file: image, messageEnum: MessageEnum.image);
    }
  }

  void selectVideo(BuildContext context) async {
    File? image = await pickVideoFromGallery(context);
    if (image != null) {
      sendFileMessage(file: image, messageEnum: MessageEnum.video);
    }
  }

  void showKeyBoard() {
    focusNode.requestFocus();
  }

  void hideEmojiContainer() {
    showEmojiPicker = false;
  }

  void hideKeyBoard() {
    focusNode.unfocus();
  }

  void showEmojiContainer() {
    showEmojiPicker = true;
  }

  void toggleEmojiKeyboardContainer() {
    if (showEmojiPicker) {
      showKeyBoard();
      hideEmojiContainer();
    } else {
      hideKeyBoard();
      showEmojiContainer();
    }
  }

  void selectGIF(BuildContext context) async {
    final gif = await pickGIF(context);

    if (gif != null) {
      // ignore: use_build_context_synchronously
      ref.read(chatControllerProvider).sendGIFMessage(
            context: context,
            gifUrl: gif.url,
            recieverUserId: widget.recieverUserId,
            isGroupChat: widget.isGroupChat,
          );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
    isRecorderInit = true;
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('recording permission not granted');
    }
    await _soundRecorder!.openRecorder();
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;
    return Column(
      children: [
        isShowMessageReply ? const MessageReplyPreview() : const SizedBox(),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: TextField(
                  onTap: () {
                    if (showEmojiPicker) {
                      showEmojiPicker = false;
                      setState(() {});
                    }
                  },
                  focusNode: focusNode,
                  controller: _messageController,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      showSendButton = false;
                    } else {
                      showSendButton = true;
                    }
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      filled: true,
                      fillColor: appBarColor,
                      hintText: 'type a message',
                      prefixIcon: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    toggleEmojiKeyboardContainer();
                                  });
                                },
                                icon:
                                    const Icon(Icons.emoji_emotions_outlined)),
                            IconButton(
                                onPressed: () {
                                  selectGIF(context);
                                },
                                icon: const Icon(Icons.gif))
                          ],
                        ),
                      ),
                      suffixIcon: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  selectImage(context);
                                },
                                icon: const Icon(Icons.camera_alt)),
                            IconButton(
                                onPressed: () {
                                  selectVideo(context);
                                },
                                icon: const Icon(Icons.attach_file))
                          ],
                        ),
                      )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                  backgroundColor: tabColor,
                  child: GestureDetector(
                    onTap: () {
                      sendTextMessage();
                      ref
                          .read(messageReplyProvider.notifier)
                          .update((state) => null);
                    },
                    child: Icon(
                      showSendButton
                          ? Icons.send
                          : isRecording
                              ? Icons.close
                              : Icons.mic,
                      color: Colors.white,
                    ),
                  )),
            )
          ],
        ),
        if (showEmojiPicker)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                if (emoji.emoji.isEmpty) {
                  showSendButton = false;
                } else {
                  showSendButton = true;
                }
                setState(() {
                  _messageController.text =
                      _messageController.text + emoji.emoji;
                });
              },
            ),
          )
      ],
    );
  }
}
