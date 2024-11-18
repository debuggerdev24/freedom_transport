import 'package:flutter/material.dart';
import 'package:flutter_user/styles/styles.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const CustomButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 55,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: theme, borderRadius: BorderRadius.circular(10)),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}


