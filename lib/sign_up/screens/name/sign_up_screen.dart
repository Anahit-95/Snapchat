import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/core/common/widgets/continue_button.dart';
import 'package:snapchat/core/common/widgets/custom_text_field.dart';
import 'package:snapchat/core/common/widgets/header_text.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/sign_up/screens/birthday_screen.dart';
import 'package:snapchat/sign_up/screens/name/name_bloc/name_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const routeName = 'sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late FocusNode _firstNameFocusNode;
  late FocusNode _lastNameFocusNode;

  final NameBloc _nameBloc = NameBloc();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _firstNameFocusNode = FocusNode();
    _lastNameFocusNode = FocusNode();
    _nameBloc.add(OnChangeInputEvent(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
    ));
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _nameBloc,
      child: BlocConsumer<NameBloc, NameState>(
        listener: (context, state) {
          if (state is NameRegistered) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BirthsayScreen()),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const HeaderText(title: "What's your name?"),
                    _renderFirstNameInput(),
                    _renderLastNameInput(),
                    _renderAcceptText(),
                    _renderSignUpButton(state),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _renderFirstNameInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: CustomTextField(
        controller: _firstNameController,
        focusNode: _firstNameFocusNode,
        labelText: 'FIRST NAME',
        onChanged: (_) => _nameBloc.add(OnChangeInputEvent(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
        )),
        onFieldSubmitted: (value) =>
            FocusScope.of(context).requestFocus(_lastNameFocusNode),
      ),
    );
  }

  Widget _renderLastNameInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: CustomTextField(
        controller: _lastNameController,
        focusNode: _lastNameFocusNode,
        labelText: 'LAST NAME',
        onChanged: (_) => _nameBloc.add(OnChangeInputEvent(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
        )),
        onFieldSubmitted: (value) => _lastNameFocusNode.unfocus(),
      ),
    );
  }

  Widget _renderSignUpButton(NameState state) {
    return ContinueButton(
      onPressed: () => _renderSignUpAndAccept(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
      ),
      isEnabled: state is! ButtonIsDisabled,
      title: 'Sign Up & Accept',
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
    _nameBloc.add(SignUpAndAcceptEvent(
      firstName: firstName,
      lastName: lastName,
    ));
  }
}
