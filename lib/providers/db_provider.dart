import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/model/todo_model.dart';
import 'package:myapp/model/user_model.dart';

class DbProvider extends ChangeNotifier {
  final users = FirebaseFirestore.instance.collection('users');


  Future<UserModel?> fetchUserData(String userId) async {
    final DocumentSnapshot snapshot = await users.doc(userId).collection('userInfo').doc('info').get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      print('Fetched user data: $userData');
      return UserModel.fromMap(userData);
    } else {
      print('Document with ID $userId does not exist on the server.');
      return null;
    }
  }

  /* //get the users data from firebase
  Future<UserData?> fetchUserData(String userId) async {
    final DocumentSnapshot documentSnapshot = await users.doc(userId).get();

  if (documentSnapshot.exists) {
    // Map the document data to the UserData object
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return UserData.fromMap(data);
    } else {
      return null;
    }
  } */

  Future updateUser(UserModel user, String id) async {
    return users.doc(id).update(user.toMap());
  }

  void deleteUser(String id) async {
    await users.doc(id).delete();
    notifyListeners();
  }
  //_________________________________________________________________________________

  Future createTodo(Todo todo, String userId) async {
    final todoId = users.doc(userId).collection('todos').doc().id;
    final newTodo = todo.copyWith(id: todoId);
    await users.doc(userId).collection('todos').doc(todoId).set(newTodo.toMap());
    notifyListeners();
  }

  Stream<QuerySnapshot> fetchTodos(String userId) {
    try {
      final todoStream = users.doc(userId).collection('todos').snapshots();

      return todoStream;
    } catch (e) {
      rethrow;
    }
  }

  Future updateTodo(Todo todo, String userId, todoId) async {
    if (todoId.isEmpty) {
      print("Error: todoId is empty");
      return; // Prevent the method from proceeding
    }
    await users
        .doc(userId)
        .collection('todos')
        .doc(todoId)
        .update(todo.toMap());
    notifyListeners();
  }

  Future deleteTodo(String userId, String todoId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('todos')
          .doc(todoId)
          .delete();
      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting todo: $e");
    }
    //await users.doc(userId).collection('todos').doc(todoId).delete();
    //notifyListeners();
  }
}
