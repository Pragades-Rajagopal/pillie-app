import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pillie/app/auth/pages/login_page.dart';
import 'package:pillie/app/auth/pages/register_page.dart';
import 'package:pillie/app/pill/pages/pill_list_page.dart';
import 'package:pillie/app/profile/pages/edit_profile_page.dart';
import 'package:pillie/app/user/services/user_service.dart';
import 'package:pillie/utils/cron/cron.dart';
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
            body: Center(child: CupertinoActivityIndicator()),
          );
        }
        final session = snapshot.hasData ? snapshot.data!.session : null;
        // TODO: Implement error handling
        if (session != null) {
          return FutureBuilder(
            future: UserService().getUser(session.user.id),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CupertinoActivityIndicator()),
                );
              }
              if (userSnapshot.hasData &&
                  userSnapshot.data != null &&
                  userSnapshot.data!.isNotEmpty) {
                return const PillListPage();
              } else {
                return EditProfilePage(userId: snapshot.data!.session!.user.id);
              }
            },
          );
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
