import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart'; // Add this
import 'package:studyhub_032_031/Screens/Student/home.dart';
import 'package:studyhub_032_031/Screens/Student/login.dart';
import 'package:studyhub_032_031/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;


Future<void> main() async {
  await Supabase.initialize(
    url: 'https://klbgbytoilanzsmzuscm.supabase.co',
    anonKey: 'sb_publishable_qEYECp8IhdfeqztVi5SPJQ_dYd1-h_m',
  );
  // 1. Preserve the splash screen while initializing
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 2. Initialize Firebase with a check
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyHub',
      // We remove the splash inside AuthGate once we know where to go
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the stream hasn't finished its first check, show nothing
        // (The native splash is still covering the screen)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // 3. Once we have data (or error), remove the splash screen
        FlutterNativeSplash.remove();

        if (snapshot.hasData) {
          return const HomePage();
        }

        return const LoginPage();
      },
    );
  }
}