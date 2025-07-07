import 'package:flutter/material.dart';
import 'package:pillie/app/auth/services/auth_service.dart';
import 'package:pillie/components/text_button.dart';
import 'package:pillie/components/text_form_field.dart';
import 'package:pillie/components/text_link.dart';

class LoginPage extends StatefulWidget {
  final Function() togglePage;
  const LoginPage({
    super.key,
    required this.togglePage,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    try {
      // Check if email and password text fields are not null
      if (_formKey.currentState!.validate()) {
        await authService.signIn(email, password);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppTextFormField(
                    labelText: 'Email',
                    textController: _emailController,
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return "Email is mandatory";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppTextFormField(
                    labelText: 'Password',
                    textController: _passwordController,
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return "Password is mandatory with 6 char";
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(height: 14),
                  AppTextButton(buttonText: 'Login', onTap: login),
                  const SizedBox(height: 14),
                  AppTextLink(
                    onTap: widget.togglePage,
                    linkText: 'Sign up',
                    prefixText: 'New to the app?',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
