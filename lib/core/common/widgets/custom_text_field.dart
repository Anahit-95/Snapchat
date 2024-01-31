import 'package:flutter/material.dart';
import 'package:snapchat/core/utils/consts/colors.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    required this.controller,
    required this.labelText,
    this.focusNode,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.onFieldSubmitted,
    super.key,
  });
  final TextEditingController controller;
  final String labelText;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final bool obscureText;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          autofocus: true,
          decoration: InputDecoration(
            suffix: widget.obscureText
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        isObscured = !isObscured;
                      });
                    },
                    child: isObscured
                        ? const Icon(
                            Icons.visibility_off,
                            color: AppColors.disabled,
                          )
                        : const Icon(
                            Icons.visibility,
                            color: AppColors.disabled,
                          ),
                  )
                : null,
            labelText: widget.labelText,
            labelStyle: const TextStyle(
              color: AppColors.disabled,
              fontSize: 14,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.disabled,
              ),
            ),
            errorStyle: const TextStyle(
              fontSize: 14,
              color: Colors.red,
            ),
          ),
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText ? isObscured : false,
          controller: widget.controller,
          focusNode: widget.focusNode,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
        ),
      ],
    );
  }
}
