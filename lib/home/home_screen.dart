import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:snapchat/core/common/repositories/database_repository/database_repo_impl.dart';
import 'package:snapchat/core/common/repositories/validation_repository/validation_repo_impl.dart';
import 'package:snapchat/core/common/widgets/continue_button.dart';
import 'package:snapchat/core/common/widgets/custom_text_field.dart';
import 'package:snapchat/core/common/widgets/header_text.dart';
import 'package:snapchat/core/enums/edit_field_name.dart';
import 'package:snapchat/core/models/country_model.dart';
import 'package:snapchat/core/models/user_model.dart';
import 'package:snapchat/core/providers/country_notifier.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/countries/countries_screen.dart';
import 'package:snapchat/home/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:snapchat/log_in/log_in_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.user, super.key});

  final UserModel user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final EditProfileBloc _editProfileBloc = EditProfileBloc(
    validationRepo: ValidationRepoImpl(),
    dbRepo: DatabaseRepoImpl(),
  );

  late CountryNotifier _countryNotifier;

  DateTime? _selectedDate;
  CountryModel? _selectedCountry;

  @override
  void initState() {
    // _countryNotifier.getCountry();
    _firstNameController.text = widget.user.firstName;
    _lastNameController.text = widget.user.lastName;
    _dateController.text =
        DateFormat('d MMMM yyyy').format(widget.user.birthday);
    _usernameController.text = widget.user.username;
    _emailController.text = widget.user.email ?? '';
    _phoneController.text = widget.user.phoneNumber ?? '';
    _passwordController.text = widget.user.password;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _countryNotifier = Provider.of(context, listen: false);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _editProfileBloc,
      child: BlocBuilder<EditProfileBloc, EditProfileState>(
        builder: (context, state) {
          print(widget.user);
          print(state.runtimeType);
          return _render(state);
        },
      ),
    );
  }

  Widget _render(EditProfileState state) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, right: 40, left: 40),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _renderHeader(),
                _renderFirstNameInput(),
                _renderErrorText(state, EditFieldName.firstName),
                _renderLastNameInput(),
                _renderErrorText(state, EditFieldName.lastName),
                _renderBirthdayInput(),
                _renderErrorText(state, EditFieldName.birthday),
                _renderUsernameInput(),
                _renderErrorText(state, EditFieldName.username),
                _renderEmailInput(),
                _renderErrorText(state, EditFieldName.email),
                _renderMobileInput(),
                _renderErrorText(state, EditFieldName.phone),
                _renderPasswordInput(),
                _renderErrorText(state, EditFieldName.password),
                _renderSaveButton(state)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const HeaderText(
          title: 'Edit Profile',
          fontSize: 22,
          color: AppColors.blueText1,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, LogInScreen.routeName);
          },
          child: const Icon(Icons.logout_sharp),
        )
      ],
    );
  }

  Widget _renderFirstNameInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 4),
      child: CustomTextField(
        controller: _firstNameController,
        labelText: 'FIRST NAME',
        onChanged: (_) => _onChangeInputs(),
      ),
    );
  }

  Widget _renderErrorText(EditProfileState state, EditFieldName fieldName) {
    if (state is InvalidEditState) {
      String errorText;
      switch (fieldName) {
        case EditFieldName.firstName:
          errorText = state.firstNameError;
          break;
        case EditFieldName.lastName:
          errorText = state.lastNameError;
          break;
        case EditFieldName.birthday:
          errorText = state.birthdayError;
          break;
        case EditFieldName.username:
          errorText = state.usernameError;
          break;
        case EditFieldName.email:
          errorText = state.emailError;
          break;
        case EditFieldName.phone:
          errorText = state.phoneError;
          break;
        case EditFieldName.password:
          errorText = state.passwordError;
        default:
          errorText = '';
      }
      return SizedBox(
        width: double.maxFinite,
        height: 15,
        child: Text(
          errorText,
          style: const TextStyle(color: Colors.red, fontSize: 12),
        ),
      );
    } else {
      return const SizedBox(height: 15);
    }
  }

  Widget _renderLastNameInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: CustomTextField(
        controller: _lastNameController,
        labelText: 'LAST NAME',
        onChanged: (_) => _onChangeInputs(),
      ),
    );
  }

  Widget _renderBirthdayInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: TextField(
        autofocus: true,
        readOnly: true,
        controller: _dateController,
        keyboardType: TextInputType.datetime,
        decoration: const InputDecoration(
          labelText: 'BIRTHDAY',
          labelStyle: TextStyle(
            color: AppColors.disabled,
            fontSize: 14,
          ),
        ),
        onTap: _openDatePicker,
      ),
    );
  }

  Future<void> _openDatePicker() async {
    FocusScope.of(context).unfocus();
    final currentDate = DateTime.now();
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.white,
          height: 250,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _selectedDate ?? widget.user.birthday,
            minimumDate: DateTime(1900),
            maximumDate: currentDate,
            dateOrder: DatePickerDateOrder.dmy,
            onDateTimeChanged: (newDate) {
              _selectedDate = newDate;
              _dateController.text =
                  DateFormat('d MMMM yyyy').format(_selectedDate!);
              _onChangeInputs();
            },
          ),
        );
      },
    );
  }

  Widget _renderUsernameInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: CustomTextField(
        controller: _usernameController,
        labelText: 'USERNAME',
        onChanged: (_) => _onChangeInputs(),
      ),
    );
  }

  Widget _renderEmailInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: CustomTextField(
        controller: _emailController,
        labelText: 'EMAIL',
        onChanged: (_) => _onChangeInputs(),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  Widget _renderMobileInput() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 2),
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
      style: TextStyle(color: AppColors.disabled, fontSize: 13),
    );
  }

  // 2. Future builder verson of getting devices local country

  Widget _renderMobileInputFlagAndPhonCode() {
    // return FutureBuilder(
    //   future: _getDeviceCountry(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       _selectedCountry ??= snapshot.data;
    return Consumer(
      builder: (context, value, child) {
        return GestureDetector(
          onTap: _onTapNavigateCountriesScreen,
          child: Text(
            _selectedCountry != null
                ? '${_selectedCountry!.getFlagEmoji} +${_selectedCountry!.phoneCode}'
                : widget.user.phoneNumber != null
                    ? '$getFlagEmoji +${widget.user.phoneCode}'
                    : '+',
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.blueText2,
            ),
          ),
        );
      },
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
        controller: _phoneController,
        decoration: const InputDecoration(border: InputBorder.none),
        keyboardType: TextInputType.phone,
        onChanged: (_) => _onChangeInputs(),
      ),
    );
  }

  Widget _renderPasswordInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: CustomTextField(
        controller: _passwordController,
        labelText: 'PASSWORD',
        obscureText: true,
        onChanged: (_) => _onChangeInputs(),
      ),
    );
  }

  Widget _renderSaveButton(EditProfileState state) {
    return ContinueButton(
      onPressed: _onPressedSave,
      isEnabled: state is! InvalidEditState,
      title: 'Save',
      top: 40,
    );
  }

  String get getFlagEmoji {
    final flag = widget.user.countryCode!.toUpperCase().replaceAllMapped(
        RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
    return flag;
  }

  void _onTapNavigateCountriesScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CountriesScreen(countryNotifier: _countryNotifier),
      ),
    );
  }

  void _onChangeInputs() {
    _editProfileBloc.add(EditingOnChangeEvent(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      birthday: _selectedDate ?? widget.user.birthday,
      username: _usernameController.text,
      email: _emailController.text,
      phoneCode: _selectedCountry != null
          ? _selectedCountry!.phoneCode
          : widget.user.phoneNumber != null
              ? widget.user.phoneCode
              : null,
      phoneNumber: _phoneController.text,
      password: _passwordController.text,
      user: widget.user,
    ));
  }

  void _onPressedSave() => _editProfileBloc.add(
        SaveProfileChanges(
          username: widget.user.username,
          user: widget.user.copyWith(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            birthday: _selectedDate ?? widget.user.birthday,
            username: _usernameController.text,
            email: _emailController.text.isEmpty ? null : _emailController.text,
            phoneCode: _phoneController.text.isEmpty
                ? null
                : _selectedCountry != null
                    ? _selectedCountry!.phoneCode
                    : widget.user.phoneCode,
            phoneNumber:
                _phoneController.text.isEmpty ? null : _phoneController.text,
            password: _passwordController.text,
          ),
        ),
      );
}
