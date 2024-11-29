import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, this.onTap});
  final Function()? onTap;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    usernameController.dispose();
    usernameFocusNode.dispose();
    confirmPasswordController.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Handle FirebaseAuth errors
  String _handleAuthError(String errorCode) {
    if (emailController.text.isEmpty) {
      return 'Email cannot be empty';
    } else if (passwordController.text.isEmpty) {
      return 'Password cannot be empty';
    } else if (passwordController.text.length < 8) {
      return 'Password must be at least 8 characters';
    } else if (passwordController.text != confirmPasswordController.text) {
      return 'Passwords do not match';
    }
    switch (errorCode) {
      case 'invalid-email':
        return 'Invalid email';
      case 'invalid-credential':
        return 'Invalid credentials';
      case 'user-disabled':
        return 'User disabled';
      case 'user-not-found':
        return 'No user found';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'This email is currently being used by another account';
      default:
        return 'Something went wrong';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Icon(
                    Icons.message,
                    size: 50,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Sign up',
                    style: TextStyle(color: Colors.grey[700], fontSize: 24),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MyTextField(
                    fillColor: Colors.grey[200],
                    controller: usernameController,
                    focusNode: usernameFocusNode,
                    hintText: 'username',
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    fillColor: Colors.grey[200],
                    controller: emailController,
                    focusNode: emailFocusNode,
                    hintText: 'email',
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    fillColor: Colors.grey[200],
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    hintText: 'password',
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    fillColor: Colors.grey[200],
                    controller: confirmPasswordController,
                    focusNode: confirmPasswordFocusNode,
                    hintText: 'confirm password',
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyButton(
                    text: 'Sign up',
                    onTap: () async {
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();
                      final username = usernameController.text.trim();
                      try {
                        // Show loading indicator
                        showDialog(
                          context: context,
                          builder: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        );
                        // Perform registration
                        await context.read<BaseAuth>().createUser(
                              email,
                              password,
                              username,
                            );
                        // Navigate to HomePage and hide loading indicator

                        Navigator.of(context).pop(); // Hide loading indicator
                        Navigator.of(context).pushNamed('/home');
                      } on FirebaseAuthException catch (e) {
                        // Handle Firebase errors
                        Navigator.of(context).pop(); // Hide loading indicator
                        String errorMessage = _handleAuthError(e.code);
                        _showErrorSnackBar(context, errorMessage);
                      } catch (e) {
                        // Handle other unexpected errors
                        Navigator.of(context).pop(); // Hide loading indicator
                        _showErrorSnackBar(
                            context, 'An unexpected error occurred');
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      TextButton(
                        onPressed: widget.onTap,
                        child: Text(
                          'Log in',
                          style: TextStyle(color: Colors.grey[900]),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
