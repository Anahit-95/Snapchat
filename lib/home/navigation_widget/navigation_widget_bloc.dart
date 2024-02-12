import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat/core/common/repositories/storage_repo/storage_repo_impl.dart';
import 'package:snapchat/core/common/repositories/users_db_repository/users_db_repo_impl.dart';
import 'package:snapchat/core/models/user_model.dart';

part 'navigation_widget_event.dart';
part 'navigation_widget_state.dart';

class NavigationWidgetBloc
    extends Bloc<NavigationWidgetEvent, NavigationWidgetState> {
  NavigationWidgetBloc({
    required StorageRepoImpl storageRepo,
    required UsersDBRepoImpl dbRepo,
  })  : _storageRepo = storageRepo,
        _dbRepo = dbRepo,
        super(NavigationWidgetInitial()) {
    on<TryToGetUserEvent>(_onTryToGetUser);
  }

  final StorageRepoImpl _storageRepo;
  final UsersDBRepoImpl _dbRepo;

  Future<void> _onTryToGetUser(
      TryToGetUserEvent event, Emitter<NavigationWidgetState> emit) async {
    try {
      emit(LoadingNavigationWidget());
      final userMap = await _storageRepo.getUser();
      if (userMap != null) {
        final user = await _dbRepo.getUserByUsername(userMap['username']!);
        emit(IsOnEditProfileScreen(user!));
      } else {
        emit(IsOnStartScreen());
      }
    } catch (e) {
      emit(const NavigationWidgetError('Failed to get user.'));
    }
  }
}
