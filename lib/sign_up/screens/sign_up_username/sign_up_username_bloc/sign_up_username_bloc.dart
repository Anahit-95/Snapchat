import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat/core/common/repositories/database_repository/database_repo_impl.dart';
import 'package:snapchat/core/common/repositories/validation_repository/validation_repo_impl.dart';
import 'package:snapchat/core/models/user_model.dart';

part 'sign_up_username_event.dart';
part 'sign_up_username_state.dart';

class SignUpUsernameBloc
    extends Bloc<SignUpUsernameEvent, SignUpUsernameState> {
  SignUpUsernameBloc({
    required ValidationRepoImpl validationRepo,
    required DatabaseRepoImpl dbRepo,
  })  : _validationRepo = validationRepo,
        _dbRepo = dbRepo,
        super(UsernameInitial()) {
    on<OnChangeInputEvent>(_onOnChangeInputEvent);
  }
  final ValidationRepoImpl _validationRepo;
  final DatabaseRepoImpl _dbRepo;

  List<UserModel> _allUsers = [];

  Future<void> _onOnChangeInputEvent(
      OnChangeInputEvent event, Emitter<SignUpUsernameState> emit) async {
    if (_validationRepo.isValidUsernameAndNotEmpty(event.username)) {
      if (_allUsers.isEmpty) {
        _allUsers = await _dbRepo.getAllUsers();
      }
      if (_validationRepo.isUsernameAvailable(
          username: event.username, allUsers: _allUsers)) {
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
