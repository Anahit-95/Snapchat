import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat/core/common/repositories/validation_repository/validation_repo_impl.dart';

part 'sign_up_name_event.dart';
part 'sign_up_name_state.dart';

class SignUpNameBloc extends Bloc<SignUpNameEvent, SignUpNameState> {
  SignUpNameBloc({required ValidationRepoImpl validationRepo})
      : _validationRepo = validationRepo,
        super(NameInitial()) {
    on<OnChangeInputEvent>(_onOnChangeInput);
  }
  final ValidationRepoImpl _validationRepo;

  void _onOnChangeInput(
      OnChangeInputEvent event, Emitter<SignUpNameState> emit) {
    if (_validationRepo.isValidNameState(
      firstName: event.firstName,
      lastName: event.lastName,
    )) {
      emit(ButtonIsEnabled());
    } else {
      emit(ButtonIsDisabled());
    }
  }
}
