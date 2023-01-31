import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Features/auth/controller/auth_controller.dart';

class OTPScreen extends ConsumerWidget {
  static const routename = '/otp_screen';
  final String verificationId;
  const OTPScreen({super.key, required this.verificationId});

  verifyOTP(BuildContext context, WidgetRef ref, String userOTP) {
    ref
        .read(authControllerProvider)
        .verifyOTP(context, verificationId, userOTP);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('verifying your number'),
      ),
      body: Column(
        children: [
          Text('OTP has been sent to your Mobile Number'),
          Center(
            child: SizedBox(
              width: size.width * 0.5,
              child: TextField(
                onChanged: (value) {
                  if (value.length == 6) {
                    verifyOTP(context, ref, value);
                  }
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: '_  _  _  _  _  _',
                    hintStyle: TextStyle(fontSize: 30)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
