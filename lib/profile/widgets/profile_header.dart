import 'package:flutter/material.dart';
import 'package:snapchat/core/localizations/app_localizations.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/profile/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:snapchat/settings/settings_screen.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({required this.editProfileBloc, super.key});

  final EditProfileBloc editProfileBloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              'edit_profile'.tr(context),
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.blueText1,
              ),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                ),
                child: const Icon(Icons.settings_outlined),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => editProfileBloc.add(LogOutEvent()),
                child: const Icon(Icons.logout_sharp),
              ),
            ],
          )
        ],
      ),
    );
  }
}
