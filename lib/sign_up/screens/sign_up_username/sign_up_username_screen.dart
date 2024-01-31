import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/core/common/widgets/continue_button.dart';
import 'package:snapchat/core/common/widgets/custom_back_button.dart';
import 'package:snapchat/core/common/widgets/custom_text_field.dart';
import 'package:snapchat/core/common/widgets/header_text.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/sign_up/screens/sign_up_email_phone/sign_up_email_phone_screen.dart';
import 'package:snapchat/sign_up/screens/sign_up_username/sign_up_username_bloc/sign_up_username_bloc.dart';

class SignUpUsernameScreen extends StatefulWidget {
  const SignUpUsernameScreen({super.key});

  @override
  State<SignUpUsernameScreen> createState() => _SignUpUsernameScreenState();
}

class _SignUpUsernameScreenState extends State<SignUpUsernameScreen> {
  late TextEditingController _controller;

  final SignUpUsernameBloc _usernameBloc = SignUpUsernameBloc();

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _usernameBloc,
      child: BlocBuilder<SignUpUsernameBloc, SignUpUsernameState>(
        builder: (context, state) {
          return _render(state);
        },
      ),
    );
  }

  Widget _render(SignUpUsernameState state) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomBackButton(),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(60),
                  child: Column(
                    children: [
                      const HeaderText(title: 'Pick a username'),
                      _renderDescription(),
                      _renderUsernameInput(),
                      _rederAvailable(state),
                      _renderContinueButton(state)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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

  Widget _renderUsernameInput() {
    return CustomTextField(
      controller: _controller,
      labelText: 'USERNAME',
      onChanged: (_) => _usernameBloc.add(OnChangeInputEvent(_controller.text)),
    );
  }

  Widget _rederAvailable(SignUpUsernameState state) {
    return Container(
      width: double.maxFinite,
      height: 25,
      padding: const EdgeInsets.only(top: 10),
      child: (state is UsernameAvailable)
          ? const Text(
              'Username available',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: AppColors.greyText2,
                fontSize: 12,
              ),
            )
          : (state is InvalidUsername)
              ? Text(
                  state.usernameError,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                )
              : null,
    );
  }

  Widget _renderContinueButton(SignUpUsernameState state) {
    return ContinueButton(
      onPressed: _continuePressed,
      isEnabled: _controller.text.length >= 5 && state is! InvalidUsername,
      title: 'Continue',
    );
  }

  void _continuePressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpEmailPhoneScreen()),
    );
  }
}
