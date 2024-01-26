import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snapchat/core/common/widgets/continue_button.dart';
import 'package:snapchat/core/common/widgets/header_text.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/sign_up/screens/username_screen.dart';

class BirthsayScreen extends StatefulWidget {
  const BirthsayScreen({super.key});

  @override
  State<BirthsayScreen> createState() => _BirthsayScreenState();
}

class _BirthsayScreenState extends State<BirthsayScreen> {
  late TextEditingController _dateController;
  DateTime? _selectedDate;

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

  void _renderContinue(DateTime birthdate) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UsernameScreen()),
    );
  }

  void _openDatePicker() async {
    FocusScope.of(context).unfocus();
    DateTime currentDate = DateTime.now();
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 250,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _selectedDate ?? currentDate,
            minimumDate: DateTime(1900),
            // maximumDate: currentDate,
            dateOrder: DatePickerDateOrder.dmy,
            onDateTimeChanged: (newDate) {
              setState(() {
                _selectedDate = newDate;
                _dateController.text =
                    DateFormat('d MMMM yyyy').format(_selectedDate!);
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 60, left: 60, right: 60),
        child: Column(
          children: [
            const HeaderText(title: "When's your birthday?"),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: TextField(
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
            ),
            ContinueButton(
              onPressed: () => _renderContinue(_selectedDate!),
              isEnabled: _dateController.text.isNotEmpty,
              title: 'Continue',
            )
          ],
        ),
      ),
    );
  }
}
