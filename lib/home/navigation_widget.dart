import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:snapchat/core/localizations/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:snapchat/core/common/repositories/storage_repo/storage_repo_impl.dart';
import 'package:snapchat/core/common/repositories/users_db_repository/users_db_repo_impl.dart';
import 'package:snapchat/core/database/database_helper.dart';
import 'package:snapchat/core/localizations/app_localizations.dart';
import 'package:snapchat/core/providers/locale_notifier.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/home/navigation_widget/navigation_widget_bloc.dart';
import 'package:snapchat/log_in/log_in_screen.dart';
import 'package:snapchat/profile/edit_profile_screen.dart';
import 'package:snapchat/sign_up/screens/sign_up_name/sign_up_name_screen.dart';
import 'package:snapchat/start_screen/start_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocaleNotifier(store: StorageRepoImpl()),
      child: BlocProvider(
        create: (context) => NavigationWidgetBloc(
          storageRepo: StorageRepoImpl(),
          dbRepo: UsersDBRepoImpl(DatabaseHelper()),
        )..add(TryToGetUserEvent()),
        child: Consumer<LocaleNotifier>(
          builder: (_, localeNotifier, __) {
            return _renderMaterialApp(localeNotifier);
          },
        ),
      ),
    );
  }

  MaterialApp _renderMaterialApp(LocaleNotifier localeNotifier) {
    return MaterialApp(
      title: 'Snapchat',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ru', 'RU'),
        Locale('hy', 'AM'),
      ],
      locale: localeNotifier.appLocale,
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        for (final locale in supportedLocales) {
          if (deviceLocale != null &&
              deviceLocale.languageCode == locale.languageCode) {
            return deviceLocale;
          }
        }
        return supportedLocales.first;
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) {
          return BlocBuilder<NavigationWidgetBloc, NavigationWidgetState>(
              builder: (context, state) {
            if (state is IsOnStartScreen) {
              return const StartScreen();
            } else if (state is IsOnEditProfileScreen) {
              return EditProfileScreen(user: state.user);
            } else if (state is NavigationWidgetError) {
              return Scaffold(
                body: Center(
                  child: Text(
                    state.error,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              );
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          });
        },
        LogInScreen.routeName: (context) => const LogInScreen(),
        SignUpNameScreen.routeName: (context) => const SignUpNameScreen(),
      },
    );
  }
}
