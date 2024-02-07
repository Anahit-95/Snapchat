part of 'navigation_widget_bloc.dart';

sealed class NavigationWidgetState extends Equatable {
  const NavigationWidgetState();

  @override
  List<Object> get props => [];
}

final class NavigationWidgetInitial extends NavigationWidgetState {}

final class IsOnStartScreen extends NavigationWidgetState {}

final class IsOnEditProfileScreen extends NavigationWidgetState {
  const IsOnEditProfileScreen(this.user);

  final UserModel user;

  @override
  List<Object> get props => [user];
}

final class LoadingNavigationWidget extends NavigationWidgetState {}

final class NavigationWidgetError extends NavigationWidgetState {
  const NavigationWidgetError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
