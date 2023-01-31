import 'package:flutter/material.dart';
import 'package:whatsapp_clone/Common/widgets/error.dart';
import 'package:whatsapp_clone/Features/Landing/Screens/Landing_Screen.dart';
import 'package:whatsapp_clone/Features/auth/screens/login_screen.dart';
import 'package:whatsapp_clone/Features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/Features/auth/screens/user_infromation_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routename:
      return MaterialPageRoute(builder: (context) => LoginScreen());

    case LandingScreen.routename:
      return MaterialPageRoute(builder: (context) => LandingScreen());

    case UserScreen.routename:
      return MaterialPageRoute(builder: (context) => UserScreen());

    case OTPScreen.routename:
      return MaterialPageRoute(
          builder: (context) => OTPScreen(
                verificationId: settings.arguments.toString(),
              ));

    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
                  body: ErrorScreen(
                error: 'this page does not exist',
              )));
  }
}
