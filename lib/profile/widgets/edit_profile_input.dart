import 'package:flutter/material.dart';

import 'package:snapchat/core/common/widgets/custom_text_field.dart';

class EditProfileInput extends StatelessWidget {
  const EditProfileInput({
    required this.controller,
    required this.labelText,
    this.isObscured = false,
    this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String labelText;
  final bool isObscured;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: CustomTextField(
        controller: controller,
        labelText: labelText,
        onChanged: onChanged,
        obscureText: isObscured,
      ),
    );
  }
}
