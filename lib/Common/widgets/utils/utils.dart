import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const defaultPhotoUrl =
    'https://png.pngitem.com/pimgs/s/130-1300400_user-hd-png-download.png';
void showSnakBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(content.toString())));
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnakBar(context, e.toString());
  }
  return image;
}
