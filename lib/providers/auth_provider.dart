import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/model/user_model.dart';
import 'package:myapp/providers/db_provider.dart';

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
      // ignore: avoid_print
      print(e.code);
      rethrow;
    }
  }

  //sign out
  Future<void> signOut() async {
    await auth.signOut();
    notifyListeners();
  }

  // sign up
  Future<UserCredential?> createUser(
      String email, String password, String username) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final uid = userCredential.user!.uid;
      final userModel = UserModel(username: username, email: email, id: uid);
      dbProvider.createUser(
        userModel,
      );
      notifyListeners();

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      rethrow;
    }
  }
}
