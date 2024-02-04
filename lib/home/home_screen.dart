import 'package:flutter/material.dart';
import 'package:snapchat/core/models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.user, super.key});

  final UserModel user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('First Name: ${widget.user.firstName}'),
              Text('Last Name: ${widget.user.lastName}'),
              Text('Birthday: ${widget.user.birthday}'),
              Text('Username: ${widget.user.username}'),
              Text('Email: ${widget.user.email ?? '-'}'),
              Text('Phone: ${widget.user.phoneNumber ?? '-'}'),
            ],
          ),
        ),
      ),
    );
  }
}
