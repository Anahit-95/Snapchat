import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/core/common/widgets/continue_button.dart';
import 'package:snapchat/core/common/widgets/custom_back_button.dart';
import 'package:snapchat/core/common/widgets/custom_text_field.dart';
import 'package:snapchat/core/common/widgets/header_text.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/sign_up/screens/sign_up_birthday/sign_up_birthday_screen.dart';
import 'package:snapchat/sign_up/screens/sign_up_name/sign_up_name_bloc/sign_up_name_bloc.dart';

class SignUpNameScreen extends StatefulWidget {
  const SignUpNameScreen({super.key});
  static const routeName = 'sign-up';

  @override
  State<SignUpNameScreen> createState() => _SignUpNameScreenState();
}

class _SignUpNameScreenState extends State<SignUpNameScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late FocusNode _firstNameFocusNode;
  late FocusNode _lastNameFocusNode;

  final SignUpNameBloc _nameBloc = SignUpNameBloc();

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _nameBloc,
      child: BlocBuilder<SignUpNameBloc, SignUpNameState>(
        // listener: _listener,
        builder: (context, state) {
          return _render(state);
        },
      ),
    );
  }

  Widget _render(SignUpNameState state) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomBackButton(),
              Padding(
                padding: const EdgeInsets.all(60),
                child: Column(
                  children: [
                    const HeaderText(title: "What's your name?"),
                    _renderFirstNameInput(),
                    _renderLastNameInput(),
                    _renderAcceptText(),
                    _renderSignUpButton(state),
                  ],
                ),
              ),
            ],
          ),
        ),
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

  Widget _renderSignUpButton(SignUpNameState state) {
    return ContinueButton(
      onPressed: _renderSignUpAndAccept,
      isEnabled: state is! ButtonIsDisabled && state is! NameInitial,
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

  void _renderSignUpAndAccept() {
    if (_firstNameFocusNode.hasFocus) {
      _firstNameFocusNode.unfocus();
    }
    if (_lastNameFocusNode.hasFocus) {
      _lastNameFocusNode.unfocus();
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpBirthdayScreen(),
      ),
    );
    // _nameBloc.add(SignUpAndAcceptEvent(
    //   firstName: _firstNameController.text,
    //   lastName: _lastNameController.text,
    // ));
  }
}

// extension _BlocAddition on _SignUpNameScreenState {
//   void _listener(BuildContext context, SignUpNameState state) {
//     if (state is NameRegistered) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const SignUpBirthsayScreen(),
//         ),
//       );
//     }
//   }
// }
