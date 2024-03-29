import 'package:flutter/material.dart';
import 'package:snapchat/core/utils/consts/colors.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({
    required this.onPressed,
    required this.isEnabled,
    required this.title,
    this.top = 100,
    super.key,
  });
  final void Function()? onPressed;
  final bool isEnabled;
  final String title;
  final double top;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: top),
      width: MediaQuery.of(context).size.width * .6,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.disabled,
            disabledForegroundColor: AppColors.white),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
