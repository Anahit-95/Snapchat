part of 'navigation_widget_bloc.dart';

sealed class NavigationWidgetEvent extends Equatable {
  const NavigationWidgetEvent();

  @override
  List<Object> get props => [];
}

final class TryToGetUserEvent extends NavigationWidgetEvent {}
