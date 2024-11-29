import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/components/my_button.dart';
import 'package:myapp/components/my_text_field.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.onTap});
  final Function()? onTap;

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Handle FirebaseAuth errors
  String _handleAuthError(String errorCode) {
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
                  onTap: () async {
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();
                    try {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              const Center(child: CircularProgressIndicator()));
                      // Call signIn method
                      await context.read<BaseAuth>().signIn(email, password);
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed('/home');
                    } catch (e) {
                      Navigator.pop(context);
                      // Handle error here (you can display a SnackBar, show a dialog, or anything else)
                      String errorMessage = 'Something went wrong';
                      if (e is FirebaseAuthException) {
                        errorMessage = _handleAuthError(e.code);
                      }

                      // Show error message (using SnackBar in this case)
                      _showErrorSnackBar(context, errorMessage);
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
        ),
      ),
    );
  }
}
