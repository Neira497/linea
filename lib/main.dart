import 'package:flutter/material.dart';
import 'package:linea/pages/login_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.brown,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.brown,
        ).copyWith(secondary: Colors.brown),
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
