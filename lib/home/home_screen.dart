import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:snapchat/core/common/repositories/database_repository/database_repo_impl.dart';
import 'package:snapchat/core/common/repositories/validation_repository/validation_repo_impl.dart';
import 'package:snapchat/core/common/widgets/continue_button.dart';
import 'package:snapchat/core/common/widgets/custom_text_field.dart';
import 'package:snapchat/core/common/widgets/header_text.dart';
import 'package:snapchat/core/models/user_model.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/home/edit_profile_bloc/edit_profile_bloc.dart';

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

  DateTime? _selectedDate;

  @override
  void initState() {
    _firstNameController.text = widget.user.firstName;
    _lastNameController.text = widget.user.lastName;
    _dateController.text =
        DateFormat('d MMMM yyyy').format(widget.user.birthday);
    _usernameController.text = widget.user.username;
    _emailController.text = widget.user.email ?? '';
    _phoneController.text = widget.user.phoneNumber != null
        ? widget.user.phoneNumber!.split(' ')[1]
        : '';
    _passwordController.text = widget.user.password;
    super.initState();
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
          print(state.runtimeType);
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 30, right: 40, left: 40),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeaderText(
                        title: 'Edit Profile',
                        fontSize: 22,
                        color: AppColors.blueText1,
                      ),
                      _renderFirstNameInput(),
                      _renderFirstNameErrorText(state),
                      _renderLastNameInput(),
                      _renderLastNameErrorText(state),
                      _renderBirthdayInput(),
                      _renderBirthdayErrorText(state),
                      _renderUsernameInput(),
                      _renderUsernameErrorText(state),
                      _renderEmailInput(),
                      _renderMobileInput(),
                      _renderPasswordInput(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        width: double.maxFinite,
                        child: ContinueButton(
                          onPressed: () {},
                          isEnabled: true,
                          title: 'Save',
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
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

  Widget _renderFirstNameErrorText(EditProfileState state) {
    if (state is InvalidEditState && state.firstNameError.isNotEmpty) {
      return SizedBox(
        width: double.maxFinite,
        height: 15,
        child: Text(
          state.firstNameError,
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

  Widget _renderLastNameErrorText(EditProfileState state) {
    if (state is InvalidEditState && state.lastNameError.isNotEmpty) {
      return SizedBox(
        width: double.maxFinite,
        height: 15,
        child: Text(
          state.lastNameError,
          style: const TextStyle(color: Colors.red, fontSize: 12),
        ),
      );
    } else {
      return const SizedBox(height: 15);
    }
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

  Widget _renderBirthdayErrorText(EditProfileState state) {
    if (state is InvalidEditState && state.birthdayError.isNotEmpty) {
      return SizedBox(
        width: double.maxFinite,
        height: 15,
        child: Text(
          state.birthdayError,
          style: const TextStyle(color: Colors.red, fontSize: 12),
        ),
      );
    } else {
      return const SizedBox(height: 15);
    }
  }

  Future<void> _openDatePicker() async {
    FocusScope.of(context).unfocus();
    final currentDate = DateTime.now();
    final firstValidDate = currentDate.subtract(
      const Duration(days: 16 * 365 + 4),
    );
    // _selectedDate ?? _birthdayBloc.add(SelectingDate(firstValidDate));
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 250,
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
              print(_selectedDate);
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

  // Widget _rederAvailable(EditProfileState state) {
  //   return Container(
  //     width: double.maxFinite,
  //     height: 25,
  //     padding: const EdgeInsets.only(top: 10),
  //     child: (state is ValidEditState)
  //         ? const Text(
  //             'Username available',
  //             textAlign: TextAlign.start,
  //             style: TextStyle(
  //               color: AppColors.greyText2,
  //               fontSize: 12,
  //             ),
  //           )
  //         : (state is InvalidEditState)
  //             ? Text(
  //                 state.usernameError,
  //                 style: const TextStyle(color: Colors.red, fontSize: 12),
  //               )
  //             : null,
  //   );
  // }

  Widget _renderUsernameErrorText(EditProfileState state) {
    if (state is InvalidEditState && state.usernameError.isNotEmpty) {
      return SizedBox(
        width: double.maxFinite,
        height: 15,
        child: Text(
          state.usernameError,
          style: const TextStyle(color: Colors.red, fontSize: 12),
        ),
      );
    } else {
      return const SizedBox(height: 15);
    }
  }

  Widget _renderEmailInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: CustomTextField(
        controller: _emailController,
        labelText: 'EMAIL',
        // onChanged: (_) =>
        //     _emailPhoneBloc.add(EmailOnChangeEvent(_emailController.text)),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  // Widget _renderEmailErrorText(SignUpEmailPhoneState state) {
  //   if (state is InvalidEmail) {
  //     return SizedBox(
  //       width: double.maxFinite,
  //       height: 15,
  //       child: Text(
  //         state.emailError,
  //         style: const TextStyle(color: Colors.red, fontSize: 12),
  //       ),
  //     );
  //   } else {
  //     return const SizedBox(height: 15);
  //   }
  // }

  Widget _renderMobileInput() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 0),
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
    return GestureDetector(
      // onTap: _onTapNavigateCountriesScreen,
      child: Text(
        widget.user.phoneNumber != null
            ? widget.user.phoneNumber!.split(' ')[0]
            : '+',
        // '${_selectedCountry?.getFlagEmoji ?? _selectedCountry!.countryCode} +${_selectedCountry!.phoneCode}',
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
        controller: _phoneController,
        decoration: const InputDecoration(border: InputBorder.none),
        keyboardType: TextInputType.phone,
        // onChanged: (_) => _emailPhoneBloc.add(PhoneOnChangeEvent(
        //   phoneCode: _selectedCountry!.phoneCode,
        //   phoneNumber: _mobileController.text,
        // )),
      ),
    );
  }

  // Widget _renderPhoneErrorText(SignUpEmailPhoneState state) {
  //   if (state is InvalidPhone) {
  //     return SizedBox(
  //       width: double.maxFinite,
  //       height: 15,
  //       child: Text(
  //         state.phoneError,
  //         style: const TextStyle(color: Colors.red, fontSize: 12),
  //       ),
  //     );
  //   } else {
  //     return const SizedBox(height: 15);
  //   }
  // }

  Widget _renderPasswordInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: CustomTextField(
        controller: _passwordController,
        labelText: 'PASSWORD',
        obscureText: true,
        // onChanged: (_) =>
        //     _passwordBloc.add(OnChangePasswordInputEvent(_controller.text)),
      ),
    );
  }

  // Widget _renderPasswordErrorText(SignUpPasswordState state) {
  //   if (state is InvalidPassword) {
  //     return SizedBox(
  //       width: double.maxFinite,
  //       height: 15,
  //       child: Text(
  //         state.passwordError,
  //         style: const TextStyle(color: Colors.red, fontSize: 12),
  //       ),
  //     );
  //   } else {
  //     return const SizedBox(height: 15);
  //   }
  // }

  void _onChangeInputs() {
    _editProfileBloc.add(EditingOnChangeEvent(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      birthday: _selectedDate ?? widget.user.birthday,
      username: _usernameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
      user: widget.user,
    ));
  }
}
