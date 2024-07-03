import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'create_cv_screen.dart';
import 'firebase_options.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'resetpasswordscreen.dart';
import 'update_cv_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // ignore: prefer_const_constructors
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CV Functionality Maker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/createCv': (context) => const CreateCvScreen(),
        '/updateCv': (context) => const UpdateCvScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
      },
    );
  }
}
