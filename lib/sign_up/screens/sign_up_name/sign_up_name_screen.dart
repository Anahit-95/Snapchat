import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/core/common/repositories/validation_repository/validation_repo_impl.dart';
import 'package:snapchat/core/common/widgets/continue_button.dart';
import 'package:snapchat/core/common/widgets/custom_back_button.dart';
import 'package:snapchat/core/common/widgets/custom_text_field.dart';
import 'package:snapchat/core/common/widgets/header_text.dart';
import 'package:snapchat/core/localizations/app_localizations.dart';
import 'package:snapchat/core/models/user_model.dart';
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

  final SignUpNameBloc _nameBloc =
      SignUpNameBloc(validationRepo: ValidationRepoImpl());

  final user = UserModel();

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
                    HeaderText(title: 'what_is_your_name'.tr(context)),
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
        labelText: 'first_name'.tr(context),
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
        labelText: 'last_name'.tr(context),
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
      title: 'sign_up_and_accept'.tr(context),
    );
  }

  RichText _renderAcceptText() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
            color: AppColors.black, fontSize: 12, fontWeight: FontWeight.w300),
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
    user
      ..firstName = _firstNameController.text
      ..lastName = _lastNameController.text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpBirthdayScreen(
          user: user,
        ),
      ),
    );
  }
}
