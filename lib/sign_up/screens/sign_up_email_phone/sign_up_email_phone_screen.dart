import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/core/common/widgets/continue_button.dart';
import 'package:snapchat/core/common/widgets/custom_back_button.dart';
import 'package:snapchat/core/common/widgets/custom_text_field.dart';
import 'package:snapchat/core/common/widgets/header_text.dart';
import 'package:snapchat/core/models/country_model.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/countries/countries_screen.dart';
import 'package:snapchat/sign_up/screens/sign_up_email_phone/sign_up_email_phone_bloc/sign_up_email_phone_bloc.dart';
import 'package:snapchat/sign_up/screens/sign_up_password/sign_up_password_screen.dart';

enum SignUpMode { email, phone }

class SignUpEmailPhoneScreen extends StatefulWidget {
  const SignUpEmailPhoneScreen({super.key});

  @override
  State<SignUpEmailPhoneScreen> createState() => _SignUpEmailPhoneScreenState();
}

class _SignUpEmailPhoneScreenState extends State<SignUpEmailPhoneScreen> {
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late FocusNode _emailFocusNode;
  late FocusNode _mobileFocusNode;
  String countryCode = 'am';
  CountryModel? selectedCountry = const CountryModel(
    phoneCode: '374',
    countryCode: 'AM',
    level: 1,
    countryName: 'Armenia',
    example: '77123456',
  );

  SignUpMode _signUpMode = SignUpMode.email;

  final SignUpEmailPhoneBloc _emailPhoneBloc = SignUpEmailPhoneBloc();

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _emailPhoneBloc,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomBackButton(),
                Padding(
                  padding: const EdgeInsets.all(60),
                  child:
                      BlocBuilder<SignUpEmailPhoneBloc, SignUpEmailPhoneState>(
                    builder: (context, state) {
                      return _render(state);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _render(SignUpEmailPhoneState state) {
    if (_signUpMode == SignUpMode.phone) {
      return _renderPhoneMode(state);
    }
    return _renderEmailMode(state);
  }

  Widget _renderEmailMode(SignUpEmailPhoneState state) {
    return Column(
      children: [
        _renderHeader("What's your email?"),
        _renderSignUpWithEmailPhone(),
        _renderEmailInput(),
        _renderEmailErrorText(state),
        _renderContinueButton(
          isEnabled: state is! InvalidEmail && _emailController.text.isNotEmpty,
        ),
      ],
    );
  }

  Widget _renderPhoneMode(SignUpEmailPhoneState state) {
    return Column(
      children: [
        _renderHeader("What's your \nmobile number?"),
        _renderSignUpWithEmailPhone(),
        _renderMobileInput(),
        _renderPhoneErrorText(state),
        _renderVarificationText(),
        _renderContinueButton(
          isEnabled:
              state is! InvalidPhone && _mobileController.text.isNotEmpty,
        ),
      ],
    );
  }

  Widget _renderHeader(String title) {
    return HeaderText(title: title);
  }

  Widget _renderEmailInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: CustomTextField(
        controller: _emailController,
        labelText: 'EMAIL',
        onChanged: (_) =>
            _emailPhoneBloc.add(EmailOnChangeEvent(_emailController.text)),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  Widget _renderSignUpWithEmailPhone() {
    return GestureDetector(
      onTap: _onTapChangeMode,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          _signUpMode == SignUpMode.phone
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

  Widget _renderEmailErrorText(SignUpEmailPhoneState state) {
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
      margin: const EdgeInsets.only(bottom: 2),
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
          _renderMobileInputLabel(),
          Row(
            children: [
              _renderMobileInputFlagAndPhonCode(),
              _renderMobileInputDivider(),
              _renderMobileInputNumberField(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _renderMobileInputLabel() {
    return const Text(
      'MOBILE NUMBER',
      style: TextStyle(color: AppColors.blueText2, fontSize: 13),
    );
  }

  Widget _renderMobileInputFlagAndPhonCode() {
    return GestureDetector(
      onTap: _onTapNavigateCountriesScreen,
      child: Text(
        '${selectedCountry?.getFlagEmoji ?? selectedCountry!.countryCode} +${selectedCountry!.phoneCode}',
        style: const TextStyle(
          fontSize: 18,
          color: AppColors.blueText2,
        ),
      ),
    );
  }

  Widget _renderMobileInputDivider() {
    return Container(
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
    );
  }

  Widget _renderMobileInputNumberField() {
    return Expanded(
      child: TextField(
        autofocus: true,
        controller: _mobileController,
        decoration: const InputDecoration(border: InputBorder.none),
        keyboardType: TextInputType.phone,
        onChanged: (_) =>
            _emailPhoneBloc.add(PhoneOnChangeEvent(_mobileController.text)),
      ),
    );
  }

  Widget _renderPhoneErrorText(SignUpEmailPhoneState state) {
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
        style: TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _renderContinueButton({required bool isEnabled}) {
    return ContinueButton(
      onPressed: _continueClicked,
      isEnabled: isEnabled,
      title: 'Continue',
    );
  }

  void _onTapChangeMode() {
    setState(() {
      if (_signUpMode == SignUpMode.email) {
        _signUpMode = SignUpMode.phone;
      } else {
        _signUpMode = SignUpMode.email;
      }
    });
  }

  void _onTapNavigateCountriesScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountriesScreen(
          onChange: (CountryModel country) {
            selectedCountry = country;
            setState(() {});
          },
        ),
      ),
    );
  }

  void _continueClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPasswordScreen()),
    );
  }
}
