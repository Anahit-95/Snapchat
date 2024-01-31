part of 'countries_bloc.dart';

sealed class CountriesState extends Equatable {
  const CountriesState();

  @override
  List<Object> get props => [];
}

final class CountriesInitial extends CountriesState {}

final class LoadingCountries extends CountriesState {}

final class CountriesLoaded extends CountriesState {
  const CountriesLoaded({required this.countries});

  final List<CountryModel> countries;

  @override
  List<Object> get props => [countries];
}

final class CountriesFound extends CountriesState {
  const CountriesFound({required this.countries});

  final List<CountryModel> countries;

  @override
  List<Object> get props => [countries];
}

final class CountriesError extends CountriesState {
  const CountriesError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
