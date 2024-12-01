import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/components/my_button.dart';
import 'package:myapp/components/my_text_field.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: LoginBody(
          onTap: onTap,
        ),
      ),
    );
  }
}

class LoginBody extends StatefulWidget {
  const LoginBody({super.key, required this.onTap});
  final VoidCallback? onTap;

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    debugPrint("Error Dialog: $message");
    /*showDialog(context: context, builder: (context) => AlertDialog(
      content: SizedBox(
        child: Center(
          child: Text(message),
        ),
      ),
    ));*/

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      return _showErrorSnackBar(context, 'All fields are required');
    }
    if (password.length < 6) {
      return _showErrorSnackBar(
          context, 'Password must be at least 6 characters long');
    }
    try {
      showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      // Call signIn method
      await context.read<BaseAuth>().signIn(email, password);
      if (mounted) {
        debugPrint("Login successful!");
        Navigator.pop(context);
        Navigator.of(context).pushNamed('/home');
      }
    } catch (e) {
      debugPrint("Login error: $e");
      if (mounted) {
        Navigator.pop(context);
      }
      // Handle error here (you can display a SnackBar, show a dialog, or anything else)
      String errorMessage = 'Something went wrong';
      if (e is FirebaseAuthException) {
        debugPrint('FirebaseAuthException code: ${e.code}');
        if (mounted) {
          errorMessage = context.read<BaseAuth>().handleAuthError(e.code);
          // Show error message (using SnackBar in this case)
          _showErrorSnackBar(context, errorMessage);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              size: 50,
              color: Colors.grey[700],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Welcome Back !!',
              style: TextStyle(color: Colors.grey[700], fontSize: 16),
            ),
            const SizedBox(
              height: 30,
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
              height: 20,
            ),
            MyButton(
              text: 'Login',
              onTap: () => _loginUser(),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Are you new here?',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                TextButton(
                  onPressed: widget.onTap,
                  child: Text(
                    'Join us',
                    style: TextStyle(color: Colors.grey[900]),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
