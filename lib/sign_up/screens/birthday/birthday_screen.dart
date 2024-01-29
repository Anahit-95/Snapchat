import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:snapchat/core/common/widgets/continue_button.dart';
import 'package:snapchat/core/common/widgets/header_text.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/sign_up/screens/birthday/birthday_bloc/birthday_bloc.dart';
import 'package:snapchat/sign_up/screens/username/username_screen.dart';

class BirthsayScreen extends StatefulWidget {
  const BirthsayScreen({super.key});

  @override
  State<BirthsayScreen> createState() => _BirthsayScreenState();
}

class _BirthsayScreenState extends State<BirthsayScreen> {
  late TextEditingController _dateController;
  DateTime? _selectedDate;

  final BirthdayBloc _birthdayBloc = BirthdayBloc();

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
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
      child: BlocConsumer<BirthdayBloc, BirthdayState>(
        listener: (context, state) {
          if (state is BirthdayConfirmed) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UsernameScreen()),
            );
          }
          if (state is BirthdaySelected) {
            _selectedDate = state.selectedDate;
            _dateController.text =
                DateFormat('d MMMM yyyy').format(state.selectedDate);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, left: 60, right: 60),
              child: Column(
                children: [
                  const HeaderText(title: "When's your birthday?"),
                  _renderBirthdayInput(),
                  _renderBirthdayErrorText(state),
                  _renderBirthdayContinueButton(state)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _renderBirthdayInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 2),
      child: TextField(
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

  Widget _renderBirthdayContinueButton(BirthdayState state) {
    return ContinueButton(
      onPressed: () => _birthdayBloc.add(ConfirmingDate(_selectedDate!)),
      isEnabled: state is! BirthdayInitial && state is! InvalidBirthday,
      title: 'Continue',
    );
  }

  Widget _renderBirthdayErrorText(BirthdayState state) {
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

  // void _renderContinue(DateTime birthdate) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const UsernameScreen()),
  //   );
  // }

  Future<void> _openDatePicker() async {
    FocusScope.of(context).unfocus();
    final currentDate = DateTime.now();
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 250,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _selectedDate ?? currentDate,
            minimumDate: DateTime(1900),
            maximumDate: currentDate,
            dateOrder: DatePickerDateOrder.dmy,
            onDateTimeChanged: (newDate) {
              // setState(() {
              //   _selectedDate = newDate;
              //   _dateController.text =
              //       DateFormat('d MMMM yyyy').format(_selectedDate!);
              // });
              _birthdayBloc.add(SelectingDate(newDate));
            },
          ),
        );
      },
    );
  }
}
