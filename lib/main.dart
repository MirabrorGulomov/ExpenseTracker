import 'package:expense_tracker_app/provider/expenses_provider.dart';
import 'package:expense_tracker_app/screens/auth/auth_screen.dart';
import 'package:expense_tracker_app/screens/home/home_screen.dart';
import 'package:expense_tracker_app/screens/splash/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/auth_provider.dart';
import './provider/auth_provider.dart' as my_auth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure initialized
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              my_auth.AuthProvider()..initializeUser(), // Use the alias
        ),
        ChangeNotifierProvider(
          create: (context) => ExpensesProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isRussian = true;
    return MaterialApp(
      locale: isRussian ? Locale("ru") : Locale("en"),
      theme: ThemeData(
        primaryColor: const Color(0xff492A53),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class AuthStateListener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data != null) {
            return HomeScreen();
          }
          return AuthScreen();
        }
        return SplashScreen(); // Or some other loading indicator
      },
    );
  }
}
