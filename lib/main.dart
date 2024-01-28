import 'package:flutter/material.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/log_in/log_in_screen.dart';
import 'package:snapchat/sign_up/screens/name/sign_up_screen.dart';
import 'package:snapchat/start_screen/start_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        '/': (context) => const StartScreen(),
        LogInScreen.routeName: (context) => const LogInScreen(),
        SignUpScreen.routeName: (context) => const SignUpScreen(),
      },
    );
  }
}
