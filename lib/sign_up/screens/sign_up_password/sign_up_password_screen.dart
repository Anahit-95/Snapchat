import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/core/common/widgets/continue_button.dart';
import 'package:snapchat/core/common/widgets/custom_back_button.dart';
import 'package:snapchat/core/common/widgets/custom_text_field.dart';
import 'package:snapchat/core/common/widgets/header_text.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/sign_up/screens/sign_up_password/sign_up_password_bloc/sign_up_password_bloc.dart';

class SignUpPasswordScreen extends StatefulWidget {
  const SignUpPasswordScreen({super.key});

  @override
  State<SignUpPasswordScreen> createState() => _SignUpPasswordScreenState();
}

class _SignUpPasswordScreenState extends State<SignUpPasswordScreen> {
  late TextEditingController _controller;

  final SignUpPasswordBloc _passwordBloc = SignUpPasswordBloc();

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
      create: (context) => _passwordBloc,
      child: BlocConsumer<SignUpPasswordBloc, SignUpPasswordState>(
        listener: _listener,
        builder: (context, state) {
          return _render(state);
        },
      ),
    );
  }

  Widget _render(SignUpPasswordState state) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomBackButton(),
            Padding(
              padding: const EdgeInsets.all(60),
              child: Column(
                children: [
                  const HeaderText(title: 'Set a password'),
                  _renderDescription(),
                  _renderPasswordInput(),
                  _renderPasswordErrorText(state),
                  _renderContinueButton(state),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _renderPasswordInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: CustomTextField(
        controller: _controller,
        labelText: 'PASSWORD',
        obscureText: true,
        onChanged: (_) =>
            _passwordBloc.add(OnChangePasswordInputEvent(_controller.text)),
      ),
    );
  }

  Widget _renderPasswordErrorText(SignUpPasswordState state) {
    if (state is InvalidPassword) {
      return SizedBox(
        width: double.maxFinite,
        height: 15,
        child: Text(
          state.passwordError,
          style: const TextStyle(color: Colors.red, fontSize: 12),
        ),
      );
    } else {
      return const SizedBox(height: 15);
    }
  }

  Widget _renderContinueButton(SignUpPasswordState state) {
    return ContinueButton(
      onPressed: () =>
          _passwordBloc.add(ConfirmingPasswordEvent(_controller.text)),
      isEnabled: state is! InvalidPassword && state is! PasswordInitial,
      title: 'Continue',
    );
  }
}

extension _BlocAddition on _SignUpPasswordScreenState {
  void _listener(BuildContext context, SignUpPasswordState state) {
    if (state is ConfirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign up completed successfully.')),
      );
    }
  }
}
