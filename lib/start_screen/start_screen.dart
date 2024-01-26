import 'package:flutter/material.dart';

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
              text: 'LOG IN',
              onTap: () => Navigator.pushNamed(context, '/login'),
            ),
            _renderButton(
              onTap: () => Navigator.pushNamed(context, 'sign-up'),
              color: Colors.blue,
              text: 'SIGN UP',
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
