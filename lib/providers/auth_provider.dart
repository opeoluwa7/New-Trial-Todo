import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/model/user_model.dart';
import 'package:myapp/providers/db_provider.dart';
import 'package:provider/provider.dart';

class BaseAuth extends ChangeNotifier {
  final auth = FirebaseAuth.instance;
  final dbProvider = DbProvider();
  // sign in
  Future<UserCredential> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      notifyListeners();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      String errorMessage = handleAuthError(e.code);
      throw FirebaseAuthException(
        message: errorMessage,
        code: e.code,
        credential: e.credential,
      );
    }
  }

  //sign out
  Future<void> signOut() async {
    await auth.signOut();
    notifyListeners();
  }

  // sign up
  Future<UserCredential?> createUser(String email, String password,
      String username, BuildContext context) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final uid = userCredential.user!.uid;
      final userModel = UserModel(username: username, email: email, id: uid);
      await context
          .read<DbProvider>()
          .users
          .doc(uid)
          .collection('userInfo')
          .doc('info')
          .set(
            userModel.toMap(),
          );
      notifyListeners();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.code);
      rethrow;
    }
  }

  // Handle FirebaseAuth errors
  String handleAuthError(String errorCode) {
    debugPrint('handleAuthError called with errorCode: $errorCode');
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'invalid-credential':
        return 'Invalid credentials';
      case 'user-disabled':
        return 'User disabled';
      case 'email-already-in-use':
        return 'Email already in use';
      case 'wrong-password':
        return 'Incorrect password';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'network-request-failed':
        return 'Network request failed';
      default:
        return 'Something went wrong';
    }
  }
}
