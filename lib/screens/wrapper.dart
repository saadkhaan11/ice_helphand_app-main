import 'package:flutter/material.dart';
import 'package:ice_helphand/provider/auth_provider.dart';
import 'package:ice_helphand/screens/bottombar_screen.dart';
import 'package:ice_helphand/screens/authenticaion/login/login_screen.dart';
import 'package:ice_helphand/screens/verifyemail/verifyemail_screen.dart';
import 'package:provider/provider.dart';
import '../models/myuser.dart';

class Wrapper extends StatefulWidget {
  static const routeName = "/wrapper";
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    if (user == null) {
      return const LoginScreen();
    } else {
      return const VerifyEmailPage();
    }
  }
}
