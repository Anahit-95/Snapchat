import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/core/common/widgets/continue_button.dart';
import 'package:snapchat/core/common/widgets/custom_text_field.dart';
import 'package:snapchat/core/common/widgets/header_text.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/sign_up/screens/email_phone/email_phone_screen.dart';
import 'package:snapchat/sign_up/screens/username/username_bloc/username_bloc.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  late TextEditingController _controller;

  final UsernameBloc _usernameBloc = UsernameBloc();

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
      child: BlocConsumer<UsernameBloc, UsernameState>(
        listener: (context, state) {
          if (state is UsernameConfirmed) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EmailPhoneScreen()),
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
          );
        },
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

  Widget _rederAvailable(UsernameState state) {
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

  Widget _renderContinueButton(UsernameState state) {
    return ContinueButton(
      onPressed: () => _usernameBloc.add(ConfirmingUsername(_controller.text)),
      isEnabled: _controller.text.length >= 5 && state is! InvalidUsername,
      title: 'Continue',
    );
  }

  // void _renderContinue(String username) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const EmailPhoneScreen()),
  //   );
  // }
}
