import 'package:flutter/material.dart';

class AfterLogin extends StatefulWidget {
  const AfterLogin({super.key});

  @override
  State<AfterLogin> createState() => _AfterLoginState();
}

class _AfterLoginState extends State<AfterLogin> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('로그인 성공!'),
      ),
    );
  }
}
