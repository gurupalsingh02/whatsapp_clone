import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:whatsapp_clone/Common/widgets/custom_button.dart';
import 'package:whatsapp_clone/Features/auth/screens/login_screen.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/router.dart';

class LandingScreen extends StatelessWidget {
  static const routename = '/landing_screen';
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            const Text(
              "Welcome To WhatsApp",
              style: TextStyle(
                  fontSize: 30,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Image.asset(
              'Assets/bg.png',
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'Read our privacy policy tap "Agree and Continue" to Accept the terms of Service',
                  style: TextStyle(color: greyColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            CustomButton(
              text: "Agree And Continue",
              color: tabColor,
              minimumsize: Size(MediaQuery.of(context).size.width * 0.75, 50),
              fun: () {
                Navigator.pushNamed(context, LoginScreen.routename);
              },
            ),
          ],
        ),
      ),
    ));
  }
}
