import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/core/common/repositories/api_repository/api_repo_impl.dart';
import 'package:snapchat/core/common/repositories/countries_db_repository/countries_db_repo_impl.dart';
import 'package:snapchat/core/common/repositories/countries_repository/countries_repo_impl.dart';
import 'package:snapchat/core/common/repositories/users_db_repository/users_db_repo_impl.dart';
import 'package:snapchat/core/common/repositories/validation_repository/validation_repo_impl.dart';
import 'package:snapchat/core/common/widgets/continue_button.dart';
import 'package:snapchat/core/common/widgets/custom_text_field.dart';
import 'package:snapchat/core/common/widgets/header_text.dart';
import 'package:snapchat/core/common/widgets/sign_screen_wrapper.dart';
import 'package:snapchat/core/database/database_helper.dart';
import 'package:snapchat/core/enums/sign_up_mode.dart';
import 'package:snapchat/core/localizations/app_localizations.dart';
import 'package:snapchat/core/models/country_model.dart';
import 'package:snapchat/core/models/user_model.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/countries/countries_screen.dart';
import 'package:snapchat/sign_up/screens/sign_up_email_phone/sign_up_email_phone_bloc/sign_up_email_phone_bloc.dart';
import 'package:snapchat/sign_up/screens/sign_up_password/sign_up_password_screen.dart';

class SignUpEmailPhoneScreen extends StatefulWidget {
  const SignUpEmailPhoneScreen({required this.user, super.key});

  final UserModel user;

  @override
  State<SignUpEmailPhoneScreen> createState() => _SignUpEmailPhoneScreenState();
}

class _SignUpEmailPhoneScreenState extends State<SignUpEmailPhoneScreen> {
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late FocusNode _emailFocusNode;
  late FocusNode _mobileFocusNode;

  // 1.1 find device local country by country picker package

  // CountryDetails details = CountryCodes.detailsForLocale();
  // Locale locale = CountryCodes.getDeviceLocale()!;

  CountryModel? _selectedCountry;
  late List<CountryModel> _countries;

  SignUpMode _signUpMode = SignUpMode.email;

  final SignUpEmailPhoneBloc _emailPhoneBloc = SignUpEmailPhoneBloc(
    validationRepo: ValidationRepoImpl(),
    dbRepo: UsersDBRepoImpl(DatabaseHelper()),
    countriesRepo: CountriesRepoImpl(
      apiRepo: ApiRepoImpl(),
      dbRepo: CountriesDBRepoImpl(DatabaseHelper()),
    ),
  );

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _mobileController = TextEditingController();
    _emailFocusNode = FocusNode();
    _mobileFocusNode = FocusNode();
    _emailPhoneBloc.add(GetCountryEvent());
    // 1.2 find device local country by country picker package
    // give values to _selected country

    // _selectedCountry = CountryModel(
    //   phoneCode: details.dialCode!.substring(1),
    //   countryCode: locale.countryCode!,
    //   level: 1,
    //   countryName: details.localizedName!,
    //   example: '77123456',
    // );
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
      child: BlocConsumer<SignUpEmailPhoneBloc, SignUpEmailPhoneState>(
        listener: _listener,
        builder: (context, state) {
          return _render(state);
        },
      ),
    );
  }

  Widget _render(SignUpEmailPhoneState state) {
    return SignScreenWrapper(
        child: _signUpMode == SignUpMode.phone
            ? _renderPhoneMode(state)
            : _renderEmailMode(state));
  }

  Widget _renderEmailMode(SignUpEmailPhoneState state) {
    return Column(
      children: [
        _renderHeader('what_is_your_email'.tr(context)),
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
        _renderHeader('what_is_your_mobile'.tr(context)),
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
        labelText: 'email'.tr(context),
        onChanged: (_) =>
            _emailPhoneBloc.add(EmailOnChangeEvent(_emailController.text)),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  Widget _renderSignUpWithEmailPhone() {
    return GestureDetector(
      onTap: () async => await _onTapChangeMode(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          _signUpMode == SignUpMode.phone
              ? 'sign_up_with_email'.tr(context)
              : 'sign_up_with_phone'.tr(context),
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
    return Text(
      'mobile_number'.tr(context),
      style: const TextStyle(color: AppColors.blueText2, fontSize: 13),
    );
  }

  // 2. Future builder verson of getting devices local country

  Widget _renderMobileInputFlagAndPhonCode() {
    // return FutureBuilder(
    //   future: _getDeviceCountry(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       _selectedCountry ??= snapshot.data;
    return GestureDetector(
      onTap: _onTapNavigateCountriesScreen,
      child: Text(
        '${_selectedCountry?.getFlagEmoji ?? _selectedCountry!.countryCode} +${_selectedCountry!.phoneCode}',
        style: const TextStyle(
          fontSize: 18,
          color: AppColors.blueText2,
        ),
      ),
    );
    //     } else {
    //       return const SizedBox.shrink();
    //     }
    //   },
    // );
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
        onChanged: (_) => _emailPhoneBloc.add(PhoneOnChangeEvent(
          phoneCode: _selectedCountry!.phoneCode,
          phoneNumber: _mobileController.text,
        )),
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
      child: Text(
        'verification_code'.tr(context),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _renderContinueButton({required bool isEnabled}) {
    return ContinueButton(
      onPressed: _continueClicked,
      isEnabled: isEnabled,
      title: 'continue'.tr(context),
    );
  }

  Future<void> _onTapChangeMode() async {
    // 3. get device local country while swithing to phone mode
    // if (_signUpMode == SignUpMode.email && _selectedCountry == null) {
    //   _selectedCountry = await _getDeviceCountry();
    // }
    setState(() {
      if (_signUpMode == SignUpMode.email) {
        _signUpMode = SignUpMode.phone;
      } else {
        _signUpMode = SignUpMode.email;
      }
    });
  }

  // Future<CountryModel> _getDeviceCountry() async {
  //   final code = View.of(context).platformDispatcher.locale.countryCode;
  //   final data =
  //       await rootBundle.loadString('assets/resources/country_codes.json');
  //   final List<dynamic> jsonList = jsonDecode(data);

  //   final countries =
  //       jsonList.map((json) => CountryModel.fromMap(json)).toList();
  //   final currentCountry =
  //       countries.firstWhere((country) => country.countryCode == code);
  //   return currentCountry;
  // }

  void _onTapNavigateCountriesScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountriesScreen(
          countries: _countries,
          onChange: (CountryModel country) {
            _selectedCountry = country;
            log('from country page $_selectedCountry');
            if (_mobileController.text.isNotEmpty) {
              _emailPhoneBloc.add(
                PhoneOnChangeEvent(
                  phoneNumber: _mobileController.text,
                  phoneCode: _selectedCountry!.phoneCode,
                ),
              );
            }
            setState(() {});
          },
        ),
      ),
    );
  }

  void _continueClicked() {
    if (_signUpMode == SignUpMode.email) {
      widget.user.email = _emailController.text;
    } else {
      widget.user.countryCode = _selectedCountry!.countryCode;
      widget.user.phoneCode = _selectedCountry!.phoneCode;
      widget.user.phoneNumber = _mobileController.text;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpPasswordScreen(user: widget.user),
      ),
    );
  }
}

extension _BlocAddition on _SignUpEmailPhoneScreenState {
  void _listener(BuildContext context, SignUpEmailPhoneState state) {
    if (state is CountryFounded) {
      _selectedCountry = state.country;
      _countries = state.countries;
    }
  }
}
