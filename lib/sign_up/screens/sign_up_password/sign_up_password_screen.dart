import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/core/common/widgets/continue_button.dart';
import 'package:snapchat/core/common/widgets/custom_text_field.dart';
import 'package:snapchat/core/common/widgets/header_text.dart';
import 'package:snapchat/core/common/widgets/sign_screen_wrapper.dart';
import 'package:snapchat/core/database_repository/database_repo_impl.dart';
import 'package:snapchat/core/models/user_model.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/core/validation_repository/validation_repo_impl.dart';
import 'package:snapchat/home/home_screen.dart';
import 'package:snapchat/sign_up/screens/sign_up_password/sign_up_password_bloc/sign_up_password_bloc.dart';

class SignUpPasswordScreen extends StatefulWidget {
  const SignUpPasswordScreen({required this.user, super.key});

  final UserModel user;

  @override
  State<SignUpPasswordScreen> createState() => _SignUpPasswordScreenState();
}

class _SignUpPasswordScreenState extends State<SignUpPasswordScreen> {
  late TextEditingController _controller;

  final SignUpPasswordBloc _passwordBloc = SignUpPasswordBloc(
    validationRepo: ValidationRepoImpl(),
    dbRepo: DatabaseRepoImpl(),
  );

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
    return SignScreenWrapper(
        child: Column(
      children: [
        const HeaderText(title: 'Set a password'),
        _renderDescription(),
        _renderPasswordInput(),
        _renderPasswordErrorText(state),
        _renderContinueButton(state),
      ],
    ));
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
      onPressed: () => _passwordBloc.add(ConfirmingPasswordEvent(
          widget.user.copyWith(password: _controller.text))),
      isEnabled: state is ValidPassword,
      title: 'Continue',
    );
  }
}

extension _BlocAddition on _SignUpPasswordScreenState {
  void _listener(BuildContext context, SignUpPasswordState state) {
    if (state is ConfirmPassword) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }
}