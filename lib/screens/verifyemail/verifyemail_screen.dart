import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ice_helphand/screens/bottombar_screen.dart';
import 'package:ice_helphand/screens/home/home_screen.dart';
import 'package:overlay_support/overlay_support.dart';

class VerifyEmailPage extends StatefulWidget {
  static const routeName = "/verifyEmail";
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isVerified = false;
  Timer? timer;
  @override
  void initState() {
    isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    }

    super.initState();
  }

  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isVerified) {
      timer!.cancel();
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user!.sendEmailVerification();
    } catch (e) {
      toast(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return isVerified
        ? BottomBarScreen()
        : Scaffold(
            body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 140),
                child: Center(
                  child: Image.asset(
                    'assets/icons/email.png',
                    height: 200,
                  ),
                ),
              ),
              Text(
                'Email Verification',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 5,
              ),
              Text('Verification Email has sent to your Mail',
                  style: TextStyle(
                    fontSize: 14,
                  )),
            ],
          ));
  }
}
