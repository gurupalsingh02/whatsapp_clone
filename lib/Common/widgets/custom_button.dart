import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Size minimumsize;
  final Color color;
  final Function fun;
  const CustomButton(
      {super.key,
      required this.text,
      required this.minimumsize,
      required this.color,
      required this.fun});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        fun();
      },
      child: Text(text),
      style: ElevatedButton.styleFrom(
          backgroundColor: color, minimumSize: minimumsize),
    );
  }
}
