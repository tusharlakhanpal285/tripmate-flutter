import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();  /*Ye Flutter engine ko initialize karta hai. Firebase initialize karna ho. Without this → crash ho sakta hai. */
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  /*Ye Firebase connect karta hai app ke saath. currentPlatform automatically detect karta hai:*/
  );
  runApp(const TripMateApp());
}

class TripMateApp extends StatelessWidget {
  const TripMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TripMate',
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(),
    );
  }
}


class AuthWrapper extends StatelessWidget {    /*➡️ Ye authentication guard hai.*/
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>( /*(Real Time Auth Listener) ➡️ StreamBuilder ek real-time listener widget hai. Ye continuously sunta hai: */
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {   /*Yaha snapshot me latest auth state aati hai. Snapshot = current data*/

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()), /*➡️ Loading spinner untill firebase checks the state*/
          );
        }

        if (snapshot.hasData) {
          return  HomeScreen(); // user logged in
        }
        return LoginScreen(); // user not logged in
      },
    );
  }
}
