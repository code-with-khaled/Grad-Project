import 'package:flutter/material.dart';
import 'package:grad_project/app/main_layout.dart';
import 'package:grad_project/features/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            if (authProvider.error != null)
              Text(authProvider.error!, style: TextStyle(color: Colors.red)),

            authProvider.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      final phone = _phoneController.text.trim();
                      final password = _passwordController.text.trim();
                      final navigator = Navigator.of(context);

                      await authProvider.login(phone, password);

                      if (authProvider.accessToken != null) {
                        navigator.push(
                          MaterialPageRoute(
                            builder: (context) => const MainLayout(),
                          ),
                        );
                      }
                    },
                    child: const Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}
