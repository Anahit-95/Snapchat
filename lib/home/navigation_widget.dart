import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:snapchat/core/common/repositories/database_repository/database_repo_impl.dart';
import 'package:snapchat/core/common/repositories/storage_repo/storage_repo_impl.dart';
import 'package:snapchat/core/models/user_model.dart';
import 'package:snapchat/core/providers/country_notifier.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/home/navigation_widget/navigation_widget_bloc.dart';
import 'package:snapchat/log_in/log_in_screen.dart';
import 'package:snapchat/profile/edit_profile_screen.dart';
import 'package:snapchat/sign_up/screens/sign_up_name/sign_up_name_screen.dart';
import 'package:snapchat/start_screen/start_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  Future<UserModel?> _getUser() async {
    final service = StorageRepoImpl();
    final userMap = await service.getUser();
    if (userMap != null) {
      final user =
          await DatabaseRepoImpl().getUserByUsername(userMap['username']!);
      return user;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snapchat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) {
          return BlocProvider(
            create: (context) => NavigationWidgetBloc(
              storageRepo: StorageRepoImpl(),
              dbRepo: DatabaseRepoImpl(),
            )..add(TryToGetUserEvent()),
            child: BlocBuilder<NavigationWidgetBloc, NavigationWidgetState>(
              builder: (context, state) {
                if (state is IsOnStartScreen) {
                  return const StartScreen();
                } else if (state is IsOnEditProfileScreen) {
                  return ChangeNotifierProvider<CountryNotifier>(
                    create: (_) => CountryNotifier(),
                    child: EditProfileScreen(user: state.user),
                  );
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
              },
            ),
          );
          // return FutureBuilder(
          //   future: _getUser(),
          //   builder: (context, snapshot) {
          //     switch (snapshot.connectionState) {
          //       case ConnectionState.none:
          //       case ConnectionState.waiting:
          //         return const Scaffold(
          //           body: Center(
          //             child: CircularProgressIndicator(),
          //           ),
          //         );

          //       case ConnectionState.active:
          //       case ConnectionState.done:
          //         if (snapshot.hasError) {
          //           return Text('Error: ${snapshot.error}');
          //         } else {
          //           final user = snapshot.data;

          //           return user != null
          //               ? ChangeNotifierProvider<CountryNotifier>(
          //                   create: (_) => CountryNotifier(),
          //                   child: EditProfileScreen(user: user))
          //               : const StartScreen();
          //         }
          //     }
          //   },
          // );
        },
        LogInScreen.routeName: (context) => const LogInScreen(),
        SignUpNameScreen.routeName: (context) => const SignUpNameScreen(),
      },
    );
  }
}
