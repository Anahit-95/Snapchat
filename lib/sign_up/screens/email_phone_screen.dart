import 'package:flutter/material.dart';
import 'package:snapchat/core/common/widgets/continue_button.dart';
import 'package:snapchat/core/common/widgets/custom_text_field.dart';
import 'package:snapchat/core/common/widgets/header_text.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/sign_up/screens/password_screen.dart';

class EmailPhoneScreen extends StatefulWidget {
  const EmailPhoneScreen({super.key});

  @override
  State<EmailPhoneScreen> createState() => _EmailPhoneScreenState();
}

class _EmailPhoneScreenState extends State<EmailPhoneScreen> {
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late FocusNode _emailFocusNode;
  late FocusNode _mobileFocusNode;
  bool _isEmailMode = true;
  String countryCode = 'am';

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _mobileController = TextEditingController();
    _emailFocusNode = FocusNode();
    _mobileFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _mobileController.dispose();
    _emailFocusNode.dispose();
    _mobileFocusNode.dispose();
    super.dispose();
  }

  void _renderContinue(String email) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PasswordScreen()),
    );
  }

  String getFlag(String countryCode) {
    String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
    return flag;
  }

  Widget _renderSignUpWithEmailPhone() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isEmailMode = !_isEmailMode;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          _isEmailMode
              ? 'Sign up with phone instead'
              : 'Sign up with email instead',
          style: const TextStyle(
            color: AppColors.blueText1,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _renderMobileInput() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.disabled,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MOBILE NUMBER',
            textAlign: TextAlign.start,
            style: TextStyle(color: AppColors.blueText2, fontSize: 13),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${getFlag(countryCode)} +374',
                style:
                    const TextStyle(fontSize: 18, color: AppColors.blueText2),
              ),
              Container(
                width: 1,
                height: 24,
                margin: const EdgeInsets.only(left: 6, right: 6),
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: AppColors.greyText2,
                      width: 1,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  autofocus: true,
                  controller: _mobileController,
                  decoration: const InputDecoration(border: InputBorder.none),
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
        ],
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
              HeaderText(
                title: _isEmailMode
                    ? "What's your email?"
                    : "What's your \nmobile number?",
              ),
              _renderSignUpWithEmailPhone(),
              if (_isEmailMode)
                CustomTextField(
                  controller: _emailController,
                  labelText: 'EMAIL',
                  onChanged: (p0) => setState(() {}),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'E-mail field is required.';
                    } else if (!value.contains('@') || !value.contains('.')) {
                      return 'Not valid e-mail.';
                    }
                    return null;
                  },
                ),
              if (!_isEmailMode) _renderMobileInput(),
              if (!_isEmailMode)
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  width: double.maxFinite,
                  child: const Text(
                    "We'll send you SMS verification code.",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ContinueButton(
                onPressed: () => _renderContinue(_emailController.text),
                isEnabled: _emailController.text.isNotEmpty ||
                    _mobileController.text.isNotEmpty,
                title: 'Continue',
              )
            ],
          ),
        ),
      ),
    );
  }
}
