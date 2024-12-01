import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: RegisterBody(
          onTap: onTap,
        ),
      ),
    );
  }
}

class RegisterBody extends StatefulWidget {
  const RegisterBody({super.key, required this.onTap});
  final VoidCallback? onTap;

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
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
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
  }

  Future signUpUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final username = usernameController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      _showErrorSnackBar(context, 'All fields are required!');
      return;
    }

    if (password.length < 6) {
      return _showErrorSnackBar(
          context, 'Password must be at least 6 characters long');
    }

    if (password != confirmPassword) {
      _showErrorSnackBar(context, 'Passwords do not match!');
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showErrorSnackBar(context, 'Invalid email address!');
      return;
    }
    try {
      // Show loading indicator
      showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      // Perform registration
      await context.read<BaseAuth>().createUser(
            email,
            password,
            username,
            context
          );
      // Navigate to HomePage and hide loading indicator

      if (mounted) {
        Navigator.of(context).pop(); // Hide loading indicator
        Navigator.of(context).pushNamed('/home');
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase errors
      if (mounted) {
        Navigator.of(context).pop(); // Hide loading indicator
        String errorMessage = context.read<BaseAuth>().handleAuthError(e.code);
        _showErrorSnackBar(context, errorMessage);
      }
    } catch (e) {
      if (mounted) {
        // Handle other unexpected errors
        Navigator.of(context).pop(); // Hide loading indicator
        _showErrorSnackBar(context, 'An unexpected error occurred');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                onTap: () => signUpUser(),
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
    );
  }
}
