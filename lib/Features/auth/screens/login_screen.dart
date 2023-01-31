import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Common/widgets/custom_button.dart';
import 'package:whatsapp_clone/Features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/Features/auth/repositories/auth_repository.dart';
import 'package:whatsapp_clone/Features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routename = '/login_screen';
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

Country? country;

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController phonecontroller = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phonecontroller.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    phonecontroller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  pick_country() {
    showCountryPicker(
        context: context,
        onSelect: (selectedcountry) {
          country = selectedcountry;
          setState(() {});
        });
  }

  void showSnakBar(String content, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(content)));
  }

  sendPhoneNumber() {
    String phonenumber = phonecontroller.text.trim();
    if (country != null && phonenumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .SignInWithPhone(context, '+${country!.phoneCode}$phonenumber');
    } else {
      showSnakBar('Please provide all required details', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: const Text('enter your mobile number'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Whatsapp will need to verify your phone number"),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  pick_country();
                },
                child: const Text("pick country"),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (country != null) Text("+${country!.phoneCode}"),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextField(
                      controller: phonecontroller,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(hintText: "phone number"),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomButton(
                    text: "Next",
                    minimumsize:
                        Size(MediaQuery.of(context).size.width * 0.5, 50),
                    color: tabColor,
                    fun: () {
                      sendPhoneNumber();
                      Navigator.pushNamed(context, OTPScreen.routename);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
