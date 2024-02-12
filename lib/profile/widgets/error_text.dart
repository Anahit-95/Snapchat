// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:snapchat/core/enums/edit_field_name.dart';
import 'package:snapchat/profile/edit_profile_bloc/edit_profile_bloc.dart';

class ErrorText extends StatelessWidget {
  const ErrorText({required this.state, required this.fieldName, super.key});

  final EditProfileState state;
  final EditFieldName fieldName;

  String getErrorText(EditProfileState state, EditFieldName fieldName) {
    var errorText = '';
    if (state is InvalidEditState) {
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
    }
    return errorText;
  }

  @override
  Widget build(BuildContext context) {
    if (state is InvalidEditState) {
      return SizedBox(
        width: double.maxFinite,
        height: 15,
        child: Text(
          getErrorText(state, fieldName),
          style: const TextStyle(color: Colors.red, fontSize: 12),
        ),
      );
    } else {
      return const SizedBox(height: 15);
    }
  }
}
