import 'package:flutter/material.dart';
import 'package:snapchat/core/utils/consts/colors.dart';

class ContinueButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isEnabled;
  final String title;
  const ContinueButton({
    super.key,
    required this.onPressed,
    required this.isEnabled,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 100),
      width: MediaQuery.of(context).size.width * .6,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor:
                isEnabled ? AppColors.primaryColor : AppColors.disabled,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.disabled,
            disabledForegroundColor: AppColors.white),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
