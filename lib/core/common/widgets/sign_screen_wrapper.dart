import 'package:flutter/material.dart';
import 'package:snapchat/core/common/widgets/custom_back_button.dart';

class SignScreenWrapper extends StatelessWidget {
  const SignScreenWrapper({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomBackButton(),
              Padding(
                padding: const EdgeInsets.all(60),
                child: child,
              )
            ],
          ),
        ),
      ),
    );
  }
}
