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

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(Icons.storefront, size: 80, color: Colors.deepPurple),
              Image.asset(
                "assets/logo.png", // your PNG
                width: 120,
                height: 120,
              ),

              Text(
                "Sales Portal",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                "Secure entry for authorized field reps",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 32),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // PHONE FIELD
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Phone Number",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),

                      TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          hintText: "Enter your phone number",
                          prefixIcon: const Icon(Icons.phone),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ), // lighter border
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.deepPurple.shade300,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // PASSWORD FIELD WITH TOGGLE
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),

                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ), // lighter border
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.deepPurple.shade300,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // INFO BOX
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.security,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Passwords are automatically generated and provided by your Regional Sales Manager.",
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      if (authProvider.error != null)
                        Text(
                          authProvider.error!,
                          style: const TextStyle(color: Colors.red),
                        ),

                      authProvider.isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  // final username = _phoneController.text.trim();
                                  // final password = _passwordController.text
                                  //     .trim();

                                  // final authProvider = context
                                  //     .read<AuthProvider>();
                                  // final navigator = Navigator.of(context);

                                  // final success = await authProvider.login(
                                  //   username,
                                  //   password,
                                  // );

                                  // if (!context.mounted) return;

                                  // if (success) {
                                  //   navigator.pushReplacement(
                                  //     MaterialPageRoute(
                                  //       builder: (_) => const MainLayout(),
                                  //     ),
                                  //   );
                                  // }
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MainLayout(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Authorize & Sign In',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 42),

              // DIVIDER SECTION
              Row(
                children: [
                  Expanded(
                    child: Divider(color: Colors.grey.shade400, thickness: 1),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.lock_outline, color: Colors.grey),
                  ),
                  Expanded(
                    child: Divider(color: Colors.grey.shade400, thickness: 1),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // FOOTER TEXT CENTERED EVEN WHEN WRAPPING
              Text(
                "AUTHORIZED PERSONNEL ONLY",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.black38),
              ),
              const SizedBox(height: 6),
              Text(
                "Unauthorized access is strictly prohibited and may be subject to legal action.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.black38),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
