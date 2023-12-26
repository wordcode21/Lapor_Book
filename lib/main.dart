import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lapor_book_app/firebase_options.dart';
import 'package:lapor_book_app/page/SpalshPage.dart';
import 'package:lapor_book_app/page/RegisterPage.dart';
import 'package:lapor_book_app/page/LoginPage.dart';
import 'package:lapor_book_app/page/dashborard/DashboardPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Firebase.initializeApp();
  runApp(MaterialApp(title: 'Lapor Book', initialRoute: '/', routes: {
    '/': (context) => const SpalshPage(),
    '/login': (context) => LoginPage(),
    '/register': (context) => const RegisterPage(),
    '/dashboard': (context) => const DashboardPage(),
    // '/add': (context) => AddFormPage(),
    // '/detail': (context) => DetailPage(),
  }));
}
