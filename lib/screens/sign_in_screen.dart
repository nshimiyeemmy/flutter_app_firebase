import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/validators.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final success = await authProvider.signIn(email, password);

    if (mounted) {
      if (success) {
        _showSnackBar('logged in successfully!');
      } else if (authProvider.errorMessage.isNotEmpty) {
        _showSnackBar(authProvider.errorMessage, isError: true);
      }
    }
  }

  void _navigateToSignUp() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const SignUpScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Welcome Back
                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please login to your account....',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                      decoration: InputDecoration(
                        labelText: 'Input Email',
                        //prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      validator: Validators.validatePassword,
                      decoration: InputDecoration(
                        labelText: 'Input Password',
                        //prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Sign In Button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _signIn,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        child: authProvider.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'LOGIN HERE',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Navigate to Sign Up
                    TextButton(
                      onPressed: authProvider.isLoading
                          ? null
                          : _navigateToSignUp,
                      child: const Text('New Here? Registration'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
