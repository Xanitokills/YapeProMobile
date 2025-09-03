import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:yapepro/screen/login_screen.dart';
import 'package:yapepro/screen/dashboard_screen.dart';

void main() {
  assert(() {
    // Asegura que ningún flag de debug painting quede activo
    debugPaintBaselinesEnabled = false;
    debugPaintSizeEnabled = false;
    return true;
  }());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/DashboardScreen',
      routes: {
        '/': (context) => const LoginScreen(),
        '/DashboardScreen': (context) => const DashboardScreen(),
      },
    );
  }
}
