import 'package:flutter/material.dart';
import 'package:snapchat/core/common/widgets/continue_button.dart';
import 'package:snapchat/core/common/widgets/custom_text_field.dart';
import 'package:snapchat/core/common/widgets/header_text.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/sign_up/screens/email_phone_screen.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
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

  void _renderContinue(String username) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmailPhoneScreen()),
    );
  }

  Widget _renderDescription() {
    return const Padding(
      padding: EdgeInsets.only(top: 10, bottom: 20),
      child: Text(
        'Your username is how friends add you \n on Snapchat.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.greyText1,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _rederAvailable() {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.only(top: 10),
      child: const Text(
        'Username available',
        textAlign: TextAlign.start,
        style: TextStyle(
          color: AppColors.greyText2,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(60),
          child: Column(
            children: [
              const HeaderText(title: 'Pick a username'),
              _renderDescription(),
              CustomTextField(
                controller: _controller,
                labelText: 'USERNAME',
                onChanged: (p0) => setState(() {}),
              ),
              if (_controller.text.isNotEmpty) _rederAvailable(),
              ContinueButton(
                onPressed: () => _renderContinue(_controller.text),
                isEnabled: _controller.text.isNotEmpty,
                title: 'Continue',
              )
            ],
          ),
        ),
      ),
    );
  }
}
