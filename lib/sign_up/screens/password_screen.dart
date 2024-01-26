import 'package:flutter/material.dart';
import 'package:snapchat/core/common/widgets/continue_button.dart';
import 'package:snapchat/core/common/widgets/custom_text_field.dart';
import 'package:snapchat/core/common/widgets/header_text.dart';
import 'package:snapchat/core/utils/consts/colors.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _renderContinue(String email) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const EmailScreen()),
    // );
  }

  Widget _renderDescription() {
    return const Padding(
      padding: EdgeInsets.only(top: 10, bottom: 20),
      child: Text(
        'Your password should be at least 8\n characters.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.greyText1,
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(60),
        child: Column(
          children: [
            const HeaderText(title: "Set a password"),
            _renderDescription(),
            CustomTextField(
              controller: _controller,
              labelText: 'PASSWORD',
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Password field is required.';
                } else if (value.length < 8) {
                  return 'Your password is to short';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
            ContinueButton(
              onPressed: () => _renderContinue(_controller.text),
              isEnabled: _controller.text.isNotEmpty,
              title: 'Continue',
            )
          ],
        ),
      ),
    );
  }
}
