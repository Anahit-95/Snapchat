import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat/core/common/repositories/users_db_repository/user_realm_repo_impl.dart';
// import 'package:snapchat/core/common/repositories/users_db_repository/users_db_repo_impl.dart';
import 'package:snapchat/core/common/repositories/validation_repository/validation_repo_impl.dart';

part 'sign_up_username_event.dart';
part 'sign_up_username_state.dart';

class SignUpUsernameBloc
    extends Bloc<SignUpUsernameEvent, SignUpUsernameState> {
  SignUpUsernameBloc({
    required ValidationRepoImpl validationRepo,
    required UserRealmRepoImpl dbRepo,
    // required UsersDBRepoImpl dbRepo,
  })  : _validationRepo = validationRepo,
        _dbRepo = dbRepo,
        super(UsernameInitial()) {
    on<OnChangeInputEvent>(_onOnChangeInputEvent);
  }
  final ValidationRepoImpl _validationRepo;
  final UserRealmRepoImpl _dbRepo;
  // final UsersDBRepoImpl _dbRepo;

  Future<void> _onOnChangeInputEvent(
      OnChangeInputEvent event, Emitter<SignUpUsernameState> emit) async {
    if (_validationRepo.isValidUsernameAndNotEmpty(event.username)) {
      final existingUser = await _dbRepo.getUserByUsername(event.username);
      if (existingUser == null) {
        emit(UsernameAvailable());
      } else {
        emit(const InvalidUsername('This username is already in use.'));
      }
    } else {
      emit(
        const InvalidUsername('Your username must have at least 5 characters'),
      );
    }
  }
}
