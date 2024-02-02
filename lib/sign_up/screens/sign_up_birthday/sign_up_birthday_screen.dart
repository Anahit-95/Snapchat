import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:snapchat/core/common/widgets/continue_button.dart';
import 'package:snapchat/core/common/widgets/header_text.dart';
import 'package:snapchat/core/common/widgets/sign_screen_wrapper.dart';
import 'package:snapchat/core/models/user_model.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/core/validation_repository/validation_repo_impl.dart';
import 'package:snapchat/sign_up/screens/sign_up_birthday/sign_up_birthday_bloc/sign_up_birthday_bloc.dart';
import 'package:snapchat/sign_up/screens/sign_up_username/sign_up_username_screen.dart';

class SignUpBirthdayScreen extends StatefulWidget {
  const SignUpBirthdayScreen({required this.user, super.key});

  final UserModel user;

  @override
  State<SignUpBirthdayScreen> createState() => _SignUpBirthdayScreenState();
}

class _SignUpBirthdayScreenState extends State<SignUpBirthdayScreen> {
  late TextEditingController _dateController;
  DateTime? _selectedDate;

  final SignUpBirthdayBloc _birthdayBloc =
      SignUpBirthdayBloc(repoImpl: ValidationRepoImpl());

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _birthdayBloc.add(OpenDatePickerEvent());
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _birthdayBloc,
      child: BlocConsumer<SignUpBirthdayBloc, SignUpBirthdayState>(
        listener: _listener,
        builder: (context, state) {
          return _render(state);
        },
      ),
    );
  }

  Widget _render(SignUpBirthdayState state) {
    return SignScreenWrapper(
      child: Column(
        children: [
          const HeaderText(title: "When's your birthday?"),
          _renderBirthdayInput(),
          _renderBirthdayErrorText(state),
          _renderBirthdayContinueButton(state)
        ],
      ),
    );
  }

  Widget _renderBirthdayInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 2),
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

  Widget _renderBirthdayContinueButton(SignUpBirthdayState state) {
    return ContinueButton(
      onPressed: _continuePressed,
      isEnabled: state is ValidBirthday,
      title: 'Continue',
    );
  }

  Widget _renderBirthdayErrorText(SignUpBirthdayState state) {
    if (state is InvalidBirthday) {
      return const SizedBox(
        width: double.maxFinite,
        height: 15,
        child: Text(
          'You must be at least 16 year old.',
          style: TextStyle(color: Colors.red, fontSize: 12),
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
    _selectedDate ?? _birthdayBloc.add(SelectingDate(firstValidDate));
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 250,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _selectedDate ?? firstValidDate,
            minimumDate: DateTime(1900),
            maximumDate: currentDate,
            dateOrder: DatePickerDateOrder.dmy,
            onDateTimeChanged: (newDate) {
              _birthdayBloc.add(SelectingDate(newDate));
            },
          ),
        );
      },
    );
  }

  void _continuePressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpUsernameScreen(
            user: widget.user.copyWith(birthday: _selectedDate)),
      ),
    );
  }
}

extension _BlocAddition on _SignUpBirthdayScreenState {
  void _listener(BuildContext context, SignUpBirthdayState state) {
    if (state is OpenDatePicker) {
      _openDatePicker();
    }
    if (state is BirthdaySelected) {
      _selectedDate = state.selectedDate;
      _dateController.text =
          DateFormat('d MMMM yyyy').format(state.selectedDate);
    }
  }
}
