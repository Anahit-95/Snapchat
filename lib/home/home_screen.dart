import 'package:flutter/material.dart';
import 'package:snapchat/core/database_repository/database_repo_impl.dart';
import 'package:snapchat/core/models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserModel>? users;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          child: Text('get users'),
          onPressed: () async {
            users = await DatabaseRepoImpl().getAllUsers();
            setState(() {});
          },
        ),
      ),
    );
  }
}
