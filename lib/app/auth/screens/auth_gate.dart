import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pillie/app/auth/screens/login_page.dart';
import 'package:pillie/app/auth/screens/register_page.dart';
import 'package:pillie/app/home/screens/pill_list_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool showLoginPage = true;

  void togglePage() {
    setState(() => showLoginPage = !showLoginPage);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return const PillListPage();
        } else {
          if (showLoginPage) {
            return LoginPage(togglePage: togglePage);
          } else {
            return RegisterPage(togglePage: togglePage);
          }
        }
      },
    );
  }
}
