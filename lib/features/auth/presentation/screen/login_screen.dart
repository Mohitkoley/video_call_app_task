import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_calling/core/extension/context_ext.dart';
import 'package:video_calling/core/extension/num_ext.dart';
import 'package:video_calling/core/mixin/validator_mixin.dart';
import 'package:video_calling/core/routes/app_router.gr.dart';
import 'package:video_calling/core/shared/widgets/body/common_singlescrollview.dart';
import 'package:video_calling/core/shared/widgets/button/common_button.dart';
import 'package:video_calling/core/shared/widgets/textfield/common_textfield.dart';
import 'package:video_calling/features/auth/presentation/bloc/bloc/auth_bloc.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ValidatorMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isVisible = true;

  void changeVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Login Successful')));
            context.router.replace(
              UsersListRoute(currentUserId: state.user.uid),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: CommonSingleScrollview(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonTextField(
                    controller: emailController,
                    hintText: 'Email',
                    validator: isValidEmail,
                  ),
                  const SizedBox(height: 16),
                  CommonTextField(
                    hintText: "Password",
                    controller: passwordController,
                    validator: isValidPassword,
                    errorWidget: const SizedBox(),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: isVisible,
                    changeObsecure: changeVisibility,
                  ),
                  const SizedBox(height: 24),
                  CommonButton.buildElevatedButton(
                    onPressed: () {
                      if (state is AuthLoading) return;
                      if (_formKey.currentState!.validate()) {
                        final email = emailController.text;
                        final password = passwordController.text;
                        context.read<AuthBloc>().add(
                          AuthSignInEvent(email: email, password: password),
                        );
                      }
                    },
                    text: state is AuthLoading ? 'Loading...' : 'Login',
                  ),
                  30.hBox,
                  GestureDetector(
                    onTap: () {
                      context.router.push(const SignUpRoute());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: context.bodyMedium.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
