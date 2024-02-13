import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
import 'package:snapchat/core/common/repositories/api_repository/api_repo_impl.dart';
import 'package:snapchat/core/common/repositories/countries_db_repository/countries_db_repo_impl.dart';
import 'package:snapchat/core/common/repositories/countries_repository/countries_repo_impl.dart';
import 'package:snapchat/core/common/repositories/storage_repo/storage_repo_impl.dart';
import 'package:snapchat/core/common/repositories/users_db_repository/users_db_repo_impl.dart';
import 'package:snapchat/core/common/repositories/validation_repository/validation_repo_impl.dart';
import 'package:snapchat/core/common/widgets/continue_button.dart';
import 'package:snapchat/core/common/widgets/custom_text_field.dart';
import 'package:snapchat/core/database/database_helper.dart';
import 'package:snapchat/core/enums/edit_field_name.dart';
import 'package:snapchat/core/localizations/app_localizations.dart';
import 'package:snapchat/core/models/country_model.dart';
// import 'package:snapchat/core/models/country_model.dart';
import 'package:snapchat/core/models/user_model.dart';
// import 'package:snapchat/core/providers/country_notifier.dart';
import 'package:snapchat/core/providers/country_value_notifier.dart';
import 'package:snapchat/home/navigation_widget/navigation_widget_bloc.dart';
import 'package:snapchat/profile/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:snapchat/profile/widgets/birthday_input.dart';
// import 'package:snapchat/profile/widgets/edit_profile_input.dart';
import 'package:snapchat/profile/widgets/mobile_input.dart';
import 'package:snapchat/profile/widgets/profile_header.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({required this.user, super.key});

  final UserModel user;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final EditProfileBloc _editProfileBloc = EditProfileBloc(
    validationRepo: ValidationRepoImpl(),
    dbRepo: UsersDBRepoImpl(DatabaseHelper()),
    countriesRepo: CountriesRepoImpl(
      apiRepo: ApiRepoImpl(),
      dbRepo: CountriesDBRepoImpl(DatabaseHelper()),
    ),
    storageRepo: StorageRepoImpl(),
  );

  // // ChangeNotifier
  // late CountryNotifier _countryNotifier;

  // ValueNotifier
  final CountryValueNotifier _valueNotifier = CountryValueNotifier();
  List<CountryModel> _countries = [];

  late DateTime _selectedDate;
  // CountryModel? _selectedCountry;

  @override
  void initState() {
    _firstNameController.text = widget.user.firstName!;
    _lastNameController.text = widget.user.lastName!;
    _dateController.text =
        DateFormat('d MMMM yyyy').format(widget.user.birthday!);
    _selectedDate = widget.user.birthday!;
    _usernameController.text = widget.user.username!;
    _emailController.text = widget.user.email ?? '';
    _phoneController.text = widget.user.phoneNumber ?? '';
    _passwordController.text = widget.user.password!;
    _editProfileBloc.add(GetCountryEvent(widget.user.countryCode));
    _valueNotifier.addListener(_changeCountryListener);
    // ChangeNotifier with listener

    // _countryNotifier = Provider.of(context, listen: false);
    // _countryNotifier.addListener(updateCountry);
    super.initState();
  }

  //// ChangeNotifier with listener
  ///
  // void updateCountry() {
  //   setState(() {
  //     _selectedCountry = _countryNotifier.country;
  //   });
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ChangeNotifier with consumer
    // _countryNotifier = Provider.of(context, listen: false);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _valueNotifier.removeListener(_changeCountryListener);

    // ChangeNotifier with listener
    // _countryNotifier.removeListener(updateCountry);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _editProfileBloc,
      child: BlocConsumer<EditProfileBloc, EditProfileState>(
        listener: _listener,
        builder: (context, state) {
          return _render(state);
        },
      ),
    );
  }

  Widget _render(EditProfileState state) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, right: 40, left: 40),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProfileHeader(editProfileBloc: _editProfileBloc),
                _renderProfileInput(
                  labelText: 'first_name'.tr(context),
                  controller: _firstNameController,
                ),
                _renderErrorText(state, EditFieldName.firstName),
                _renderProfileInput(
                  controller: _lastNameController,
                  labelText: 'last_name'.tr(context),
                ),
                _renderErrorText(state, EditFieldName.lastName),
                BirthdayInput(
                  dateController: _dateController,
                  selectedDate: _selectedDate,
                  onDateTimeChanged: _onDateTimeChanged,
                ),
                _renderErrorText(state, EditFieldName.birthday),
                _renderProfileInput(
                  controller: _usernameController,
                  labelText: 'username'.tr(context),
                ),
                _renderErrorText(state, EditFieldName.username),
                _renderProfileInput(
                  controller: _emailController,
                  labelText: 'email'.tr(context),
                ),
                _renderErrorText(state, EditFieldName.email),
                MobileInput(
                  valueNotifier: _valueNotifier,
                  phoneController: _phoneController,
                  countries: _countries,
                  onChanged: (_) => _onChangeInputs(),
                ),
                _renderErrorText(state, EditFieldName.phone),
                _renderProfileInput(
                  controller: _passwordController,
                  labelText: 'password'.tr(context),
                  obscureText: true,
                ),
                _renderErrorText(state, EditFieldName.password),
                _renderSaveButton(state)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderProfileInput({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: CustomTextField(
        controller: controller,
        labelText: labelText,
        obscureText: obscureText,
        onChanged: (_) => _onChangeInputs(),
      ),
    );
  }

  Widget _renderErrorText(EditProfileState state, EditFieldName fieldName) {
    if (state is InvalidEditState) {
      String errorText;
      switch (fieldName) {
        case EditFieldName.firstName:
          errorText = state.firstNameError;
          break;
        case EditFieldName.lastName:
          errorText = state.lastNameError;
          break;
        case EditFieldName.birthday:
          errorText = state.birthdayError;
          break;
        case EditFieldName.username:
          errorText = state.usernameError;
          break;
        case EditFieldName.email:
          errorText = state.emailError;
          break;
        case EditFieldName.phone:
          errorText = state.phoneError;
          break;
        case EditFieldName.password:
          errorText = state.passwordError;
        default:
          errorText = '';
      }
      return SizedBox(
        width: double.maxFinite,
        height: 15,
        child: Text(
          errorText,
          style: const TextStyle(color: Colors.red, fontSize: 12),
        ),
      );
    } else {
      return const SizedBox(height: 15);
    }
  }

  Widget _renderSaveButton(EditProfileState state) {
    return ContinueButton(
      onPressed: _onPressedSave,
      isEnabled: state is! InvalidEditState,
      title: 'Save',
      top: 40,
    );
  }

  void _onDateTimeChanged(newDate) {
    _selectedDate = newDate;
    _dateController.text = DateFormat('d MMMM yyyy').format(_selectedDate);
    _onChangeInputs();
  }

  void _changeCountryListener() => _onChangeInputs();

  void _onChangeInputs() {
    // print(_countryNotifier.country);
    _editProfileBloc.add(EditingOnChangeEvent(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      birthday: _selectedDate,
      username: _usernameController.text,
      email: _emailController.text,
      // phoneCode: _countryNotifier.country!.phoneCode,
      phoneCode: _valueNotifier.value!.phoneCode,
      phoneNumber: _phoneController.text,
      password: _passwordController.text,
      user: widget.user,
    ));
  }

  void _onPressedSave() {
    final oldUsername = widget.user.username;
    widget.user.firstName = _firstNameController.text;
    widget.user.lastName = _lastNameController.text;
    widget.user.birthday = _selectedDate;
    widget.user.username = _usernameController.text;
    widget.user.email =
        _emailController.text.isEmpty ? null : _emailController.text;
    widget.user.countryCode = _phoneController.text.isEmpty
        ? null
        // : _countryNotifier.country!.countryCode;
        : _valueNotifier.value!.countryCode;
    widget.user.phoneCode = _phoneController.text.isEmpty
        ? null
        // : _countryNotifier.country!.phoneCode;
        : _valueNotifier.value!.phoneCode;
    widget.user.phoneNumber =
        _phoneController.text.isEmpty ? null : _phoneController.text;
    widget.user.password = _passwordController.text;

    print(widget.user);
    _editProfileBloc
        .add(SaveProfileChanges(username: oldUsername!, user: widget.user));
  }
}

extension _BlocAddition on _EditProfileScreenState {
  void _listener(BuildContext context, EditProfileState state) {
    if (state is CountryFounded) {
      // _countryNotifier.setCountry(state.country);
      _valueNotifier.setCountry(state.country);
      _countries = state.countries;
    }
    if (state is UpdatedProfile) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved successfully.')),
      );
    }
    if (state is LogOutState) {
      Navigator.popUntil(context, (route) => route.isFirst);
      BlocProvider.of<NavigationWidgetBloc>(context).add(TryToGetUserEvent());
    }
  }
}
