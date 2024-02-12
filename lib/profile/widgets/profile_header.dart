import 'package:flutter/material.dart';
import 'package:snapchat/core/common/widgets/header_text.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/profile/edit_profile_bloc/edit_profile_bloc.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({required this.editProfileBloc, super.key});

  final EditProfileBloc editProfileBloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const HeaderText(
            title: 'Edit Profile',
            fontSize: 22,
            color: AppColors.blueText1,
          ),
          GestureDetector(
            onTap: () => editProfileBloc.add(LogOutEvent()),
            child: const Icon(Icons.logout_sharp),
          )
        ],
      ),
    );
  }
}
