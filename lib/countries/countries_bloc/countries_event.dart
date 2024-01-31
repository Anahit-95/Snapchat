part of 'countries_bloc.dart';

sealed class CountriesEvent extends Equatable {
  const CountriesEvent();

  @override
  List<Object> get props => [];
}

final class LoadCountriesEvent extends CountriesEvent {}

final class GetCountriesApiEvent extends CountriesEvent {}

final class SearchingCountriesEvent extends CountriesEvent {
  const SearchingCountriesEvent(this.countryName);

  final String countryName;

  @override
  List<Object> get props => [countryName];
}
