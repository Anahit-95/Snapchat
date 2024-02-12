import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat/core/common/repositories/validation_repository/validation_repo_impl.dart';

part 'sign_up_birthday_event.dart';
part 'sign_up_birthday_state.dart';

class SignUpBirthdayBloc
    extends Bloc<SignUpBirthdayEvent, SignUpBirthdayState> {
  SignUpBirthdayBloc({required ValidationRepoImpl validationRepo})
      : _validationRepo = validationRepo,
        super(BirthdayInitial()) {
    on<SelectingDate>(_onSelectingDate);
    // on<OpenDatePickerEvent>(_onOpenDatePicker);
  }
  final ValidationRepoImpl _validationRepo;

  FutureOr<void> _onSelectingDate(
      SelectingDate event, Emitter<SignUpBirthdayState> emit) {
    emit(BirthdaySelected(event.birthDate));
    if (_validationRepo.isValidBirthday(event.birthDate)) {
      emit(ValidBirthday());
    } else {
      emit(InvalidBirthday());
    }
  }

  // void _onOpenDatePicker(
  //     OpenDatePickerEvent event, Emitter<SignUpBirthdayState> emit) {
  //   emit(OpenDatePicker());
  // }
}
