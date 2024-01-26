import 'package:flutter/material.dart';
import 'package:snapchat/core/common/widgets/continue_button.dart';
import 'package:snapchat/core/common/widgets/custom_text_field.dart';
import 'package:snapchat/core/common/widgets/header_text.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/sign_up/screens/birthday_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = 'sign-up';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late FocusNode _firstNameFocusNode;
  late FocusNode _lastNameFocusNode;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _firstNameFocusNode = FocusNode();
    _lastNameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    super.dispose();
  }

  bool _isButtonEnabled() {
    return (_firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty);
  }

  void _renderSignUpAndAccept({
    required String firstName,
    required String lastName,
  }) {
    if (_firstNameFocusNode.hasFocus) {
      _firstNameFocusNode.unfocus();
    }
    if (_lastNameFocusNode.hasFocus) {
      _lastNameFocusNode.unfocus();
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BirthsayScreen()),
    );
  }

  RichText _renderAcceptText() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
            color: AppColors.black, fontSize: 13, fontWeight: FontWeight.w300),
        children: [
          TextSpan(
            text:
                'By tapping Sign Up & Accept, you acknowledge that you have read the ',
          ),
          TextSpan(
            text: 'Privacy Policy ',
            style: TextStyle(color: AppColors.blueText2),
          ),
          TextSpan(
            text: 'and agree \nto the ',
          ),
          TextSpan(
            text: 'Terms of Service',
            style: TextStyle(color: AppColors.blueText2),
          ),
          TextSpan(
            text: '.',
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const HeaderText(title: "What's your name?"),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: CustomTextField(
                    controller: _firstNameController,
                    focusNode: _firstNameFocusNode,
                    labelText: 'FIRST NAME',
                    // errorText: 'First name field is required.',
                    onChanged: (_) => setState(() {}),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'First name field is required.';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) =>
                        FocusScope.of(context).requestFocus(_lastNameFocusNode),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: CustomTextField(
                      controller: _lastNameController,
                      focusNode: _lastNameFocusNode,
                      labelText: 'LAST NAME',
                      onChanged: (_) => setState(() {}),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Last name field is required.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) => _lastNameFocusNode.unfocus(),
                    )),
                _renderAcceptText(),
                ContinueButton(
                  onPressed: () => _renderSignUpAndAccept(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                  ),
                  isEnabled: _isButtonEnabled(),
                  title: 'Sign Up & Accept',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
