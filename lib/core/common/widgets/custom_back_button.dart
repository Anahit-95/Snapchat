import 'package:flutter/material.dart';
import 'package:snapchat/core/utils/consts/colors.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    this.onPressed,
    super.key,
  });
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 4, top: 5),
      child: BackButton(
        color: AppColors.primaryColor,
      ),
    );
  }
}
