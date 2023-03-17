import 'package:flutter/material.dart';
import 'package:whatsapp_clone/Common/widgets/error.dart';
import 'package:whatsapp_clone/Features/Landing/Screens/Landing_Screen.dart';
import 'package:whatsapp_clone/Features/auth/screens/login_screen.dart';
import 'package:whatsapp_clone/Features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/Features/auth/screens/user_infromation_screen.dart';
import 'package:whatsapp_clone/Features/group/screens/create_group_screen.dart';
import 'package:whatsapp_clone/Features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whatsapp_clone/Features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_clone/Features/status/screens/confirm_status_screen.dart';
import 'package:whatsapp_clone/Features/status/screens/status_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routename:
      return MaterialPageRoute(builder: (context) => const LoginScreen());

    case LandingScreen.routename:
      return MaterialPageRoute(builder: (context) => const LandingScreen());

    case SelectContactScreen.routename:
      return MaterialPageRoute(
          builder: (context) => const SelectContactScreen());

    case MobileChatScreen.routename:
      final arguments = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
          builder: (context) => MobileChatScreen(
                isGroupChat: arguments['isGroupChat'],
                name: arguments['name'],
                recieverUserId: arguments['recieverUserId'],
                profilePic: arguments['profilePic'],
              ));

    case UserScreen.routename:
      return MaterialPageRoute(builder: (context) => const UserScreen());

    case OTPScreen.routename:
      return MaterialPageRoute(
          builder: (context) => OTPScreen(
                verificationId: settings.arguments.toString(),
              ));

    case ConfirmStatusScreen.routename:
      final arguments = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
          builder: (context) => ConfirmStatusScreen(
                pickedImage: arguments['pickedImage'],
              ));
    case StatusScreen.routename:
      final arguments = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
          builder: (context) => StatusScreen(
                status: arguments['status'],
              ));
    case CreateGroupScreen.routename:
      return MaterialPageRoute(builder: (context) => const CreateGroupScreen());

    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
                  body: ErrorScreen(
                error: 'this page does not exist',
              )));
  }
}
