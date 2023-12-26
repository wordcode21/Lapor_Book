import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SpalshPage extends StatelessWidget {
  const SpalshPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashFull();
  }
}

class SplashFull extends StatefulWidget {
  const SplashFull({super.key});

  @override
  State<SplashFull> createState() => _SplashFullState();
}

class _SplashFullState extends State<SplashFull> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    User? user = _auth.currentUser;

    if (user != null) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, '/dashboard');
      });
    } else {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("Selamat Datang Di Aplikasi Laporan"),
        ),
      ),
    );
  }
}
