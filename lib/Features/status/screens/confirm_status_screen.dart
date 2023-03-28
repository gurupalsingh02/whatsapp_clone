import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Features/status/controllers/status_controller.dart';

class ConfirmStatusScreen extends ConsumerWidget {
  static const routename = '/confirm_status_screen';
  final File pickedImage;
  const ConfirmStatusScreen({required this.pickedImage, super.key});

  void addStatus(WidgetRef ref, BuildContext context) {
    ref
        .read(statusControllerProvider)
        .addStatus(file: pickedImage, context: context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addStatus(ref, context);
        },
        child: const Icon(Icons.done),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Image.file(pickedImage),
        ),
      ),
    );
  }
}
