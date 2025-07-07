import 'package:flutter/material.dart';
import 'package:pillie/app/auth/services/auth_service.dart';
import 'package:pillie/components/text_button.dart';
import 'package:pillie/components/text_form_field.dart';
import 'package:pillie/components/text_link.dart';

class RegisterPage extends StatefulWidget {
  final Function() togglePage;
  const RegisterPage({
    super.key,
    required this.togglePage,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authService = AuthService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void register() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password do not match'),
        ),
      );
      return;
    }

    try {
      if (_formKey.currentState!.validate()) {
        await authService.signUp(email, password);
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
                  const SizedBox(height: 16),
                  AppTextFormField(
                    labelText: 'Confirm Password',
                    textController: _confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return "Confirm password is mandatory with 6 char";
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),
                  AppTextButton(
                    buttonText: 'Sign Up',
                    onTap: register,
                    buttonColor: Colors.lightBlue,
                  ),
                  const SizedBox(height: 14),
                  AppTextLink(
                    onTap: widget.togglePage,
                    linkText: 'Login',
                    prefixText: 'Already have an account?',
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
