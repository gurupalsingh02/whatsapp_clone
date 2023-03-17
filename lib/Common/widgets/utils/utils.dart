import 'dart:io';

import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
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

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      image = File(pickedVideo.path);
    }
  } catch (e) {
    showSnakBar(context, e.toString());
  }
  return image;
}

Future<GiphyGif?> pickGIF(BuildContext context) async {
  GiphyGif? gif;
  try {
    gif = await Giphy.getGif(
        context: context, apiKey: 'VryD5DS0IOwHFGAzsv0R3bp2mjkVguAN');
  } catch (e) {
    showSnakBar(context, e.toString());
  }
  return gif;
}
