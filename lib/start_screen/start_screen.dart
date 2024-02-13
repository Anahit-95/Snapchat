import 'package:flutter/material.dart';
import 'package:snapchat/core/localizations/app_localizations.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _renderLogo(),
            _renderButton(
              color: Colors.red,
              text: 'log_in'.tr(context).toUpperCase(),
              onTap: () => Navigator.pushNamed(context, '/login'),
            ),
            _renderButton(
              onTap: () => Navigator.pushNamed(context, 'sign-up'),
              color: Colors.blue,
              text: 'sign_up'.tr(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderLogo() {
    return Expanded(
      child: Center(
        child: Image.asset(
          'assets/images/snapchat_logo_white.png',
          width: 80,
        ),
      ),
    );
  }

  Widget _renderButton({
    required Color color,
    required String text,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: color,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
