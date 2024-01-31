import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sign_up_name_event.dart';
part 'sign_up_name_state.dart';

class SignUpNameBloc extends Bloc<SignUpNameEvent, SignUpNameState> {
  SignUpNameBloc() : super(NameInitial()) {
    on<OnChangeInputEvent>(_onOnChangeInput);
  }

  void _onOnChangeInput(
      OnChangeInputEvent event, Emitter<SignUpNameState> emit) {
    if (event.firstName.isEmpty || event.lastName.isEmpty) {
      emit(ButtonIsDisabled());
    } else {
      emit(ButtonIsEnabled());
    }
  }
}
