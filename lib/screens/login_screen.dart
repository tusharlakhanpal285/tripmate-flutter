import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'package:flutter/foundation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 🔥 GOOGLE SIGN-IN FUNCTION
  Future<void> signInWithGoogle() async {
    try {

      if (kIsWeb) {
        // 🌐 WEB LOGIN
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        await FirebaseAuth.instance.signInWithPopup(googleProvider);

      } else {
        // 📱 ANDROID LOGIN
        final GoogleSignInAccount? googleUser =
        await GoogleSignIn().signIn();

        if (googleUser == null) return;

        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In Failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "TripMate",
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "plan your perfect trip",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white70,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 40),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 35),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [

                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 🔐 EMAIL LOGIN
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HomeScreen()),
                        );

                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                            Text(e.message ?? "Login Failed"),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 🔥 GOOGLE LOGIN BUTTON
                  ElevatedButton.icon(
                    onPressed: signInWithGoogle,
                    icon: const Icon(Icons.login),
                    label: const Text("Sign in with Google"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text("Create Account"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}