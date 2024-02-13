import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snapchat/core/localizations/app_localizations.dart';
import 'package:snapchat/core/utils/consts/colors.dart';

class BirthdayInput extends StatelessWidget {
  const BirthdayInput(
      {required this.dateController,
      required this.selectedDate,
      required this.onDateTimeChanged,
      super.key});
  final TextEditingController dateController;
  final DateTime selectedDate;
  final void Function(DateTime) onDateTimeChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: TextField(
        autofocus: true,
        readOnly: true,
        controller: dateController,
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(
          labelText: 'birthday'.tr(context),
          labelStyle: const TextStyle(
            color: AppColors.disabled,
            fontSize: 14,
          ),
        ),
        onTap: () => _openDatePicker(context),
      ),
    );
  }

  Future<void> _openDatePicker(BuildContext context) async {
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
            initialDateTime: selectedDate,
            minimumDate: DateTime(1900),
            maximumDate: currentDate,
            dateOrder: DatePickerDateOrder.dmy,
            onDateTimeChanged: onDateTimeChanged,
          ),
        );
      },
    );
  }
}
