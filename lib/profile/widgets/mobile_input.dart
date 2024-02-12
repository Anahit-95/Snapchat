import 'package:flutter/material.dart';
import 'package:snapchat/core/models/country_model.dart';
import 'package:snapchat/core/providers/country_value_notifier.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/countries/countries_screen.dart';

class MobileInput extends StatelessWidget {
  const MobileInput({
    required this.valueNotifier,
    required this.phoneController,
    required this.countries,
    this.onChanged,
    super.key,
  });

  final CountryValueNotifier valueNotifier;
  final TextEditingController phoneController;
  final List<CountryModel> countries;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 2),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.disabled,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _renderMobileInputLabel(),
          Row(
            children: [
              _renderMobileInputFlagAndPhonCode(),
              _renderMobileInputDivider(),
              _renderMobileInputNumberField(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _renderMobileInputLabel() {
    return const Text(
      'MOBILE NUMBER',
      style: TextStyle(color: AppColors.disabled, fontSize: 13),
    );
  }

  // // ChangeNotifier with consumer

  // Widget _renderMobileInputFlagAndPhonCode() {
  //   return Consumer<CountryNotifier>(
  //     builder: (context, countryNotifier, _) {
  //   return GestureDetector(
  //       onTap: _onTapNavigateCountriesScreen,
  //       child: Text(
  //         countryNotifier.country != null
  //             ? '${countryNotifier.country!.getFlagEmoji} +${countryNotifier.country!.phoneCode}'
  //             : widget.user.phoneNumber != null
  //                 ? '$getFlagEmoji +${widget.user.phoneCode}'
  //                 : '+',
  //         style: const TextStyle(
  //           fontSize: 18,
  //           color: AppColors.blueText2,
  //         ),
  //       ));
  //     },
  //   );
  // }

  // // ChangeNotifier with listener

  // Widget _renderMobileInputFlagAndPhonCode() {
  //   return GestureDetector(
  //     onTap: _onTapNavigateCountriesScreen,
  //     child: Text(
  //       _selectedCountry != null
  //           ? '${_selectedCountry!.getFlagEmoji} +${_selectedCountry!.phoneCode}'
  //           : widget.user.phoneNumber != null
  //               ? '$getFlagEmoji +${widget.user.phoneCode}'
  //               : '+',
  //       style: const TextStyle(
  //         fontSize: 18,
  //         color: AppColors.blueText2,
  //       ),
  //     ),
  //   );
  // }

  // For ValueNotifier

  Widget _renderMobileInputFlagAndPhonCode() {
    print(valueNotifier.value);
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return GestureDetector(
          onTap: () => _onTapNavigateCountriesScreen(context),
          child: Text(
            valueNotifier.value != null
                ? '${valueNotifier.value!.getFlagEmoji} +${valueNotifier.value!.phoneCode}'
                : '+',
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.blueText2,
            ),
          ),
        );
      },
    );
  }

  Widget _renderMobileInputDivider() {
    return Container(
      width: 1,
      height: 24,
      margin: const EdgeInsets.only(left: 6, right: 6),
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(
            color: AppColors.greyText2,
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _renderMobileInputNumberField() {
    return Expanded(
      child: TextField(
        autofocus: true,
        controller: phoneController,
        decoration: const InputDecoration(border: InputBorder.none),
        keyboardType: TextInputType.phone,
        onChanged: onChanged,
      ),
    );
  }

  void _onTapNavigateCountriesScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            // CountriesScreen(countryNotifier: _countryNotifier),
            CountriesScreen(
          countries: countries,
          countryNotifier: valueNotifier,
        ),
      ),
    );
  }
}
