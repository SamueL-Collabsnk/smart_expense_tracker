import 'package:flutter/material.dart';
import '../../../data/datasources/remote/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading
                  ? null
                  : () async {
                      setState(() => _loading = true);
                      try {
                        await _auth.signInWithEmail(
                          _emailController.text,
                          _passwordController.text,
                        );
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(context, '/dashboard');
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Error: $e")));
                      }
                      setState(() => _loading = false);
                    },
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text("Login"),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text("Sign in with Google"),
              onPressed: () async {
                final user = await _auth.signInWithGoogle();
                if (user != null && context.mounted) {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
