import 'package:flutter/material.dart';
import 'package:snapchat/core/utils/consts/colors.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({
    required this.title,
    this.fontSize = 20,
    this.color = AppColors.black,
    super.key,
  });
  final String title;
  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }
}
