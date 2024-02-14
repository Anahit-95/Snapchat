import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/core/common/repositories/api_repository/api_repo_impl.dart';
// import 'package:snapchat/core/common/repositories/countries_db_repository/countries_db_repo_impl.dart';
import 'package:snapchat/core/common/repositories/countries_db_repository/countries_realm_repo_impl.dart';
import 'package:snapchat/core/common/repositories/countries_repository/countries_repo_impl.dart';
import 'package:snapchat/core/common/widgets/custom_back_button.dart';
// import 'package:snapchat/core/database/database_helper.dart';
import 'package:snapchat/core/database/realm_db_helper.dart';
import 'package:snapchat/core/localizations/app_localizations.dart';
import 'package:snapchat/core/models/country_model.dart';
// import 'package:snapchat/core/providers/country_notifier.dart';
import 'package:snapchat/core/providers/country_value_notifier.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/countries/countries_bloc/countries_bloc.dart';

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({
    required this.countries,
    this.onChange,
    this.countryNotifier,
    super.key,
  });

  final Function(CountryModel)? onChange;
  // final CountryNotifier? countryNotifier;
  final CountryValueNotifier? countryNotifier;
  final List<CountryModel> countries;

  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  final TextEditingController _searchController = TextEditingController();

  final CountriesBloc _countriesBloc = CountriesBloc(
    countriesRepo: CountriesRepoImpl(
      apiRepo: ApiRepoImpl(),
      // dbRepo: CountriesDBRepoImpl(DatabaseHelper()),
      dbRepo: CountriesRealmRepoImpl(RealmDBHelper()),
    ),
  );

  @override
  void initState() {
    super.initState();
    // _countriesBloc.add(LoadCountriesEvent());
    if (widget.countries.isEmpty) {
      _countriesBloc.add(GetCountriesApiEvent());
    }
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
              if (state is CountriesLoaded && widget.countries.isEmpty)
                _renderCountries(state.countries),
              if (state is CountriesInitial || state is CountriesLoaded)
                _renderCountries(widget.countries),
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
        onChanged: (value) => _countriesBloc.add(SearchingCountriesEvent(
          countryName: _searchController.text,
          countries: widget.countries,
        )),
        decoration: InputDecoration(
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              Icons.search,
              color: AppColors.disabled,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(maxWidth: 38),
          hintText: 'search'.tr(context),
          hintStyle: const TextStyle(
            color: AppColors.greyText1,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: AppColors.greyText2,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
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
