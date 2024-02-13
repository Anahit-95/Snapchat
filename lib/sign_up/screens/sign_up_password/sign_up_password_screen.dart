import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:provider/provider.dart';
import 'package:snapchat/core/common/repositories/storage_repo/storage_repo_impl.dart';
import 'package:snapchat/core/common/repositories/users_db_repository/users_db_repo_impl.dart';
import 'package:snapchat/core/common/repositories/validation_repository/validation_repo_impl.dart';
import 'package:snapchat/core/common/widgets/continue_button.dart';
import 'package:snapchat/core/common/widgets/custom_text_field.dart';
import 'package:snapchat/core/common/widgets/header_text.dart';
import 'package:snapchat/core/common/widgets/sign_screen_wrapper.dart';
import 'package:snapchat/core/database/database_helper.dart';
import 'package:snapchat/core/localizations/app_localizations.dart';
import 'package:snapchat/core/models/user_model.dart';
// import 'package:snapchat/core/providers/country_notifier.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/profile/edit_profile_screen.dart';
import 'package:snapchat/sign_up/screens/sign_up_password/sign_up_password_bloc/sign_up_password_bloc.dart';

class SignUpPasswordScreen extends StatefulWidget {
  const SignUpPasswordScreen({required this.user, super.key});

  final UserModel user;

  @override
  State<SignUpPasswordScreen> createState() => _SignUpPasswordScreenState();
}

class _SignUpPasswordScreenState extends State<SignUpPasswordScreen> {
  late TextEditingController _controller;

  final SignUpPasswordBloc _passwordBloc = SignUpPasswordBloc(
    validationRepo: ValidationRepoImpl(),
    dbRepo: UsersDBRepoImpl(DatabaseHelper()),
    storageRepo: StorageRepoImpl(),
  );

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _passwordBloc,
      child: BlocConsumer<SignUpPasswordBloc, SignUpPasswordState>(
        listener: _listener,
        builder: (context, state) {
          return _render(state);
        },
      ),
    );
  }

  Widget _render(SignUpPasswordState state) {
    return SignScreenWrapper(
        child: Column(
      children: [
        const HeaderText(title: 'Set a password'),
        _renderDescription(),
        _renderPasswordInput(),
        _renderPasswordErrorText(state),
        _renderContinueButton(state),
      ],
    ));
  }

  Widget _renderDescription() {
    return const Padding(
      padding: EdgeInsets.only(top: 10, bottom: 20),
      child: Text(
        'Your password should be at least 8\n characters.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.greyText1,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _renderPasswordInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: CustomTextField(
        controller: _controller,
        labelText: 'password'.tr(context),
        obscureText: true,
        onChanged: (_) =>
            _passwordBloc.add(OnChangePasswordInputEvent(_controller.text)),
      ),
    );
  }

  Widget _renderPasswordErrorText(SignUpPasswordState state) {
    if (state is InvalidPassword) {
      return SizedBox(
        width: double.maxFinite,
        height: 15,
        child: Text(
          state.passwordError,
          style: const TextStyle(color: Colors.red, fontSize: 12),
        ),
      );
    } else {
      return const SizedBox(height: 15);
    }
  }

  Widget _renderContinueButton(SignUpPasswordState state) {
    widget.user.password = _controller.text;
    return ContinueButton(
      onPressed: () => _passwordBloc.add(ConfirmingPasswordEvent(widget.user)),
      isEnabled: state is ValidPassword,
      title: 'continue'.tr(context),
    );
  }
}

extension _BlocAddition on _SignUpPasswordScreenState {
  void _listener(BuildContext context, SignUpPasswordState state) {
    if (state is ConfirmPassword) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              // ChangeNotifierProvider(
              //   create: (context) => CountryNotifier(),
              //   child:
              EditProfileScreen(
            user: state.user,
          ),
          // ),
        ),
        (route) => route.isFirst,
      );
    }
    if (state is SignUpError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error)),
      );
    }
  }
}
