import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat/core/validation_repository/validation_repo_impl.dart';

part 'sign_up_email_phone_event.dart';
part 'sign_up_email_phone_state.dart';

class SignUpEmailPhoneBloc
    extends Bloc<SignUpEmailPhoneEvent, SignUpEmailPhoneState> {
  SignUpEmailPhoneBloc({required ValidationRepoImpl repoImpl})
      : _repoImpl = repoImpl,
        super(EmailPhoneInitial()) {
    on<EmailOnChangeEvent>(_onEmailOnChange);
    on<PhoneOnChangeEvent>(_onMobileOnChange);
  }

  final ValidationRepoImpl _repoImpl;

  void _onEmailOnChange(
      EmailOnChangeEvent event, Emitter<SignUpEmailPhoneState> emit) {
    if (_repoImpl.isValidEmail(event.email)) {
      emit(EmailMode(event.email));
    } else {
      emit(const InvalidEmail('Your email is invalid.'));
    }
  }

  void _onMobileOnChange(
      PhoneOnChangeEvent event, Emitter<SignUpEmailPhoneState> emit) {
    if (_repoImpl.isValidPhoneNumber(event.phone)) {
      emit(PhoneMode(event.phone));
    } else {
      emit(const InvalidPhone('Your phone number is invalid'));
    }
  }
}