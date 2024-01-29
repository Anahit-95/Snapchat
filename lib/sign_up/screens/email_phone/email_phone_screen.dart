import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/core/common/widgets/continue_button.dart';
import 'package:snapchat/core/common/widgets/custom_text_field.dart';
import 'package:snapchat/core/common/widgets/header_text.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/sign_up/screens/email_phone/bloc/email_phone_bloc.dart';
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
  String countryCode = 'am';

  final EmailPhoneBloc _emailPhoneBloc = EmailPhoneBloc();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _mobileController = TextEditingController();
    _emailFocusNode = FocusNode();
    _mobileFocusNode = FocusNode();
    _emailPhoneBloc.add(const SwitchModesEvent(mode: 'email'));
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
    final flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
    return flag;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _emailPhoneBloc,
        child: Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(60),
              child: BlocConsumer<EmailPhoneBloc, EmailPhoneState>(
                listener: (context, state) {
                  if (state is ConfirmedEmailOrPhone) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PasswordScreen()),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is PhoneMode || state is InvalidPhone) {
                    return Column(
                      children: [
                        _renderHeader("What's your \nmobile number?"),
                        _renderSignUpWithEmailPhone(state),
                        _renderMobileInput(),
                        _renderPhoneErrorText(state),
                        _renderVarificationText(),
                        _renderContinueButton1(
                            state: state,
                            isEnabled: _mobileController.text.isNotEmpty),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      _renderHeader("What's your email?"),
                      _renderSignUpWithEmailPhone(state),
                      _renderEmailInput(),
                      _renderEmailErrorText(state),
                      _renderContinueButton1(
                          state: state,
                          isEnabled: _emailController.text.isNotEmpty),
                    ],
                  );
                },
              ),
            ),
          ),
        ));
  }

  Widget _renderHeader(String title) {
    return HeaderText(title: title);
  }

  Widget _renderEmailInput() {
    return CustomTextField(
      controller: _emailController,
      labelText: 'EMAIL',
      onChanged: (p0) =>
          _emailPhoneBloc.add(EmailOnChangeEvent(_emailController.text)),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _renderSignUpWithEmailPhone(EmailPhoneState state) {
    return GestureDetector(
      onTap: () {
        if (state is PhoneMode || state is InvalidPhone) {
          _emailPhoneBloc.add(const SwitchModesEvent(mode: 'email'));
        } else {
          _emailPhoneBloc.add(const SwitchModesEvent(mode: 'phone'));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          state is PhoneMode || state is InvalidPhone
              ? 'Sign up with email instead'
              : 'Sign up with phone instead',
          style: const TextStyle(
            color: AppColors.blueText1,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _renderEmailErrorText(EmailPhoneState state) {
    if (state is InvalidEmail) {
      return SizedBox(
        width: double.maxFinite,
        height: 15,
        child: Text(
          state.emailError,
          style: const TextStyle(color: Colors.red, fontSize: 12),
        ),
      );
    } else {
      return const SizedBox(height: 15);
    }
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
                  onChanged: (value) => _emailPhoneBloc
                      .add(PhoneOnChangeEvent(_mobileController.text)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _renderPhoneErrorText(EmailPhoneState state) {
    if (state is InvalidPhone) {
      return SizedBox(
        width: double.maxFinite,
        height: 15,
        child: Text(
          state.phoneError,
          style: const TextStyle(color: Colors.red, fontSize: 12),
        ),
      );
    } else {
      return const SizedBox(height: 15);
    }
  }

  Widget _renderVarificationText() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      width: double.maxFinite,
      child: const Text(
        "We'll send you SMS verification code.",
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 12),
      ),
    );
  }

  // Widget _renderContinueButton(
  //     {required bool isEnabled, required Function() onPressed}) {
  //   return ContinueButton(
  //     onPressed: () => onPressed(),
  //     isEnabled: isEnabled,
  //     title: 'Continue',
  //   );
  // }

  Widget _renderContinueButton1(
      {required EmailPhoneState state, required bool isEnabled}) {
    return ContinueButton(
      onPressed: () {
        if (state is EmailMode) {
          _emailPhoneBloc.add(
            ConfirmEmailOrPhoneEvent(email: _emailController.text),
          );
        }
        if (state is PhoneMode) {
          _emailPhoneBloc.add(
            ConfirmEmailOrPhoneEvent(phone: _mobileController.text),
          );
        }
      },
      isEnabled: isEnabled,
      title: 'Continue',
    );
  }
}
