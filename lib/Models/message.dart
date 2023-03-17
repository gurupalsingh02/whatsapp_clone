// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:whatsapp_clone/Common/enums/message_enum.dart';

class Message {
  final String senderId;
  final String recieverId;
  final String text;
  final String userName;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  final String repliedText;
  final String repliedTo;
  final MessageEnum repliedMessageType;

  Message(
      {required this.repliedText,
      required this.repliedTo,
      required this.repliedMessageType,
      required this.timeSent,
      required this.senderId,
      required this.recieverId,
      required this.text,
      required this.type,
      required this.messageId,
      required this.isSeen,
      required this.userName});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'recieverId': recieverId,
      'text': text,
      'type': type.type,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
      'repliedText': repliedText,
      'repliedTo': repliedTo,
      'repliedMessageType': repliedMessageType.type,
      'userName': userName
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      userName: map['userName'] as String,
      senderId: map['senderId'] as String,
      text: map['text'] as String,
      type: (map['type'] as String).toEnum(),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      recieverId: map['recieverId'] as String,
      messageId: map['messageId'] as String,
      isSeen: map['isSeen'] as bool,
      repliedText: map['repliedText'] as String,
      repliedTo: map['repliedTo'] as String,
      repliedMessageType: (map['repliedMessageType'] as String).toEnum(),
    );
  }
}
