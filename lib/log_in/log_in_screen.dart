import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/core/common/repositories/database_repository/database_repo_impl.dart';
import 'package:snapchat/core/common/repositories/validation_repository/validation_repo_impl.dart';
import 'package:snapchat/core/common/widgets/continue_button.dart';
import 'package:snapchat/core/common/widgets/custom_text_field.dart';
import 'package:snapchat/core/common/widgets/header_text.dart';
import 'package:snapchat/core/common/widgets/sign_screen_wrapper.dart';
import 'package:snapchat/core/utils/consts/colors.dart';
import 'package:snapchat/home/home_screen.dart';
import 'package:snapchat/log_in/log_in_bloc/log_in_bloc.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});
  static const routeName = '/login';

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;

  final LogInBloc _loginBloc = LogInBloc(
    validationRepo: ValidationRepoImpl(),
    dbRepo: DatabaseRepoImpl(),
  );

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _loginBloc,
      child: BlocConsumer<LogInBloc, LogInState>(
        listener: _listener,
        builder: (context, state) {
          return _render(state);
        },
      ),
    );
  }

  Widget _render(LogInState state) {
    return SignScreenWrapper(
      child: Column(
        children: [
          const HeaderText(title: 'Log In'),
          // Email or username TextField
          _renderEmailTextField(),
          _renderEmailErrorText(state),
          // Password TextField
          _renderPasswordTextField(),
          _renderPasswordErrorText(state),
          _renderForgotPassword(),
          _renderLoginButton(state),
        ],
      ),
    );
  }

  Widget _renderEmailTextField() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 2),
      child: CustomTextField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        labelText: 'USERNAME OR EMAIL',
        keyboardType: TextInputType.emailAddress,
        onChanged: (p0) => _loginBloc.add(OnChangeInputEvent(
          email: _emailController.text,
          password: _passwordController.text,
        )),
        onFieldSubmitted: (value) =>
            FocusScope.of(context).requestFocus(_passwordFocusNode),
      ),
    );
  }

  Widget _renderEmailErrorText(LogInState state) {
    if (state is LogInInvalidState && state.emailError.isNotEmpty) {
      return SizedBox(
        width: double.maxFinite,
        height: 15,
        child: Text(
          state.emailError,
          style: const TextStyle(color: Colors.red, fontSize: 12),
        ),
      );
    } else {
      return const SizedBox(height: 15);
    }
  }

  Widget _renderPasswordTextField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: CustomTextField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        labelText: 'PASSWORD',
        obscureText: true,
        onChanged: (_) => _loginBloc.add(
          OnChangeInputEvent(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        ),
        onFieldSubmitted: (value) => _passwordFocusNode.unfocus(),
      ),
    );
  }

  Widget _renderPasswordErrorText(LogInState state) {
    if (state is LogInInvalidState && state.passwordError.isNotEmpty) {
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

  Widget _renderForgotPassword() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: GestureDetector(
        onTap: () {},
        child: const Text(
          'Forgot your password?',
          style: TextStyle(color: AppColors.blueText1),
        ),
      ),
    );
  }

  Widget _renderLoginButton(LogInState state) {
    return ContinueButton(
      onPressed: _loginPressed,
      isEnabled: state is! LogInInvalidState && state is! LogInInitial,
      title: 'Log In',
    );
  }

  void _loginPressed() {
    if (_emailFocusNode.hasFocus) {
      _emailFocusNode.unfocus();
    }
    if (_passwordFocusNode.hasFocus) {
      _passwordFocusNode.unfocus();
    }
    _loginBloc.add(LoggingInEvent(
      email: _emailController.text,
      password: _passwordController.text,
    ));
  }
}

extension _BlocAddition on _LogInScreenState {
  void _listener(BuildContext context, LogInState state) {
    if (state is LogInSuccess) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(user: state.user)),
      );
    }
    if (state is LogInError) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(state.error)));
    }
  }
}
