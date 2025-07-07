import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pillie/app/auth/services/auth_service.dart';

class PillListPage extends StatefulWidget {
  const PillListPage({super.key});

  @override
  State<PillListPage> createState() => _PillListPageState();
}

class _PillListPageState extends State<PillListPage> {
  AuthService authService = AuthService();

  Future<void> logout() async => await authService.signOut();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          onPressed: logout,
          icon: const Icon(CupertinoIcons.square_arrow_left_fill),
        ),
      ),
    );
  }
}
