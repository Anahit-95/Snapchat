import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapchat/core/providers/locale_notifier.dart';
import 'package:snapchat/core/utils/consts/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late LocaleNotifier _localeNotifier;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localeNotifier = Provider.of(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        foregroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10, bottom: 10),
              child: Text(
                'Choose language',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blueText1),
              ),
            ),
            _buildLanguageCheckbox('English', 'en', 'US'),
            _buildLanguageCheckbox('Armenian', 'hy', 'AM'),
            _buildLanguageCheckbox('Russian', 'ru', 'RU'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCheckbox(
      String languageName, String languageCode, String countryCode) {
    return Consumer<LocaleNotifier>(
      builder: (_, localeNotifier, __) {
        return CheckboxListTile(
          activeColor: AppColors.primaryColor,
          title: Row(
            children: [
              Text(
                getFlagEmoji(countryCode),
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Text(
                languageName,
              ),
            ],
          ),
          value: localeNotifier.appLocale?.languageCode == languageCode,
          onChanged: (bool? value) {
            if (value != null && value) {
              _localeNotifier.setLocale(Locale(languageCode, countryCode));
            }
          },
        );
      },
    );
  }

  String getFlagEmoji(String countryCode) {
    final flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
    return flag;
  }
}
