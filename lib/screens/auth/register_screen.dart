import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_trip/providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  static const primaryBlue = Color(0xFF4E71FF);
  static const backgroundDark = Color(0xFF121212);
  static const cardDark = Color(0xFF1E1E1E);
  static const textLight = Colors.white70;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Card(
            color: cardDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 28,
                        color: textLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign up to get started',
                      style: TextStyle(color: textLight),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: textLight),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: textLight.withOpacity(0.4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: primaryBlue),
                        ),
                      ),
                      validator: (value) =>
                          (value == null || !value.contains('@')) ? 'Enter a valid email' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: textLight),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: textLight.withOpacity(0.4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: primaryBlue),
                        ),
                      ),
                      validator: (value) =>
                          (value == null || value.length < 6) ? 'Min 6 characters' : null,
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.redAccent),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 24),
                    _isLoading
                        ? const CircularProgressIndicator(color: primaryBlue)
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                    _error = null;
                                  });

                                  final error = await authProvider.register(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim());

                                  print('Register error: $error');  // Debug console

                                  setState(() {
                                    _isLoading = false;
                                    _error = error;
                                  });

                                  if (error == null && mounted) {
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: const Text('Register'),
                            ),
                          ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Already have an account? Login',
                        style: TextStyle(color: primaryBlue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
