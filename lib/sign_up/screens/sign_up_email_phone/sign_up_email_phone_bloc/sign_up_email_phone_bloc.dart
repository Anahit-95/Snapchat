import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat/core/common/repositories/database_repository/database_repo_impl.dart';
import 'package:snapchat/core/common/repositories/validation_repository/validation_repo_impl.dart';
import 'package:snapchat/core/models/user_model.dart';

part 'sign_up_email_phone_event.dart';
part 'sign_up_email_phone_state.dart';

class SignUpEmailPhoneBloc
    extends Bloc<SignUpEmailPhoneEvent, SignUpEmailPhoneState> {
  SignUpEmailPhoneBloc({
    required ValidationRepoImpl validationRepo,
    required DatabaseRepoImpl dbRepo,
  })  : _validationRepo = validationRepo,
        _dbRepo = dbRepo,
        super(EmailPhoneInitial()) {
    on<EmailOnChangeEvent>(_onEmailOnChange);
    on<PhoneOnChangeEvent>(_onMobileOnChange);
  }

  final ValidationRepoImpl _validationRepo;
  final DatabaseRepoImpl _dbRepo;

  Future<void> _onEmailOnChange(
      EmailOnChangeEvent event, Emitter<SignUpEmailPhoneState> emit) async {
    if (_validationRepo.isValidEmail(event.email)) {
      final users = await _dbRepo.getAllUsers();
      print(users);
      final existingUser = await _dbRepo.getUserByEmail(event.email);
      if (existingUser == null) {
        emit(EmailMode(event.email));
      } else {
        emit(const InvalidEmail('This email is already in use'));
      }
    } else {
      emit(const InvalidEmail('Your email is invalid.'));
    }
  }

  Future<void> _onMobileOnChange(
      PhoneOnChangeEvent event, Emitter<SignUpEmailPhoneState> emit) async {
    if (_validationRepo.isValidPhoneNumber(event.phoneNumber)) {
      final existingUser =
          await _dbRepo.getUserByPhone(event.phoneCode, event.phoneNumber);
      if (existingUser == null) {
        emit(PhoneMode(event.phoneNumber));
      } else {
        emit(const InvalidPhone('This number is already in use'));
      }
    } else {
      emit(const InvalidPhone('Your phone number is invalid'));
    }
  }
}
