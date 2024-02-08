import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/core/common/repositories/api_repository/api_repo_impl.dart';
import 'package:snapchat/core/common/repositories/countries_repository/countries_repo_impl.dart';
import 'package:snapchat/core/common/repositories/database_repository/database_repo_impl.dart';
import 'package:snapchat/core/common/widgets/custom_back_button.dart';
import 'package:snapchat/core/models/country_model.dart';
// import 'package:snapchat/core/providers/country_notifier.dart';
import 'package:snapchat/core/providers/country_value_notifier.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/countries/countries_bloc/countries_bloc.dart';

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({super.key, this.onChange, this.countryNotifier});

  final Function(CountryModel)? onChange;
  // final CountryNotifier? countryNotifier;
  final CountryValueNotifier? countryNotifier;

  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  final TextEditingController _searchController = TextEditingController();

  final CountriesBloc _countriesBloc = CountriesBloc(
    countriesRepo:
        CountriesRepoImpl(apiRepo: ApiRepoImpl(), dbRepo: DatabaseRepoImpl()),
  );

  @override
  void initState() {
    super.initState();
    // _countriesBloc.add(LoadCountriesEvent());
    _countriesBloc.add(GetCountriesApiEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _countriesBloc,
      child: BlocBuilder<CountriesBloc, CountriesState>(
        builder: (context, state) {
          return render(state);
        },
      ),
    );
  }

  Scaffold render(CountriesState state) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomBackButton(),
              _renderSearchInput(),
              if (state is LoadingCountries) _renderLoadingText(),
              if (state is CountriesLoaded) _renderCountries(state.countries),
              if (state is CountriesFound) _renderCountries(state.countries),
              if (state is CountriesError) _renderErrorText(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderSearchInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 15, right: 15),
      child: TextField(
        controller: _searchController,
        onChanged: (value) =>
            _countriesBloc.add(SearchingCountriesEvent(_searchController.text)),
        decoration: const InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              Icons.search,
              color: AppColors.disabled,
            ),
          ),
          prefixIconConstraints: BoxConstraints(maxWidth: 38),
          hintText: 'Search',
          hintStyle: TextStyle(
            color: AppColors.greyText1,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: AppColors.greyText2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: AppColors.greyText2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderLoadingText() {
    return Container(
      padding: const EdgeInsets.only(top: 40),
      width: double.maxFinite,
      child: const Text(
        'Loading Countries...',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.greyText2,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _renderErrorText(CountriesError state) {
    return Container(
      padding: const EdgeInsets.only(top: 40),
      width: double.maxFinite,
      child: Text(
        state.error,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _renderCountries(List<CountryModel> countries) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: countries.length,
        itemBuilder: (context, index) {
          return _renderCountryTile(
            country: countries[index],
            isLast: index == countries.length - 1,
          );
        },
      ),
    );
  }

  Widget _renderCountryTile(
      {required CountryModel country, required bool isLast}) {
    return Container(
      height: 50,
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: AppColors.greyText2.withOpacity(.6),
                ),
              ),
            ),
      child: ListTile(
        onTap: () {
          if (widget.onChange != null) {
            widget.onChange?.call(country);
          } else {
            widget.countryNotifier!.setCountry(country);
          }
          Navigator.pop(context);
        },
        horizontalTitleGap: 5,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 5,
        ),
        style: ListTileStyle.list,
        leading: Text(
          country.getFlagEmoji,
          style: const TextStyle(fontSize: 20),
        ),
        title: Text(
          country.countryName,
          style: const TextStyle(color: AppColors.black),
        ),
        trailing: Text(
          country.phoneCode,
          style: const TextStyle(color: AppColors.greyText1, fontSize: 16),
        ),
      ),
    );
  }
}
