import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/model/todo_model.dart';
import 'package:myapp/model/user_model.dart';

class DbProvider {
  final users = FirebaseFirestore.instance.collection('users');
  final todos = FirebaseFirestore.instance.collection('todos');

  Future createUser(UserModel user) async {
    final Map<String, dynamic> userData = user.toMap();
    //await users.add(userData);
    await users.doc(user.id).set(userData);
  }

  /*Stream<QuerySnapshot> fetchUsers() {
    try {
      final userStream = users.snapshots();

      return userStream;
    } catch (e) {
      rethrow;
    }
  }*/

  Future<UserModel?> fetchUserData(String userId) async {
    final DocumentSnapshot snapshot = await users.doc(userId).get();

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
  }
  //_________________________________________________________________________________

  Future createTodo(Todo todo) async {
    await todos.add(todo.toMap());
  }

  Stream<QuerySnapshot> fetchTodos() {
    try {
      final todoStream = todos.snapshots();

      return todoStream;
    } catch (e) {
      rethrow;
    }
  }

  Future updateTodo(Todo todo, String id) async {
    await todos.doc(id).update(todo.toMap());
  }

  Future deleteTodo(String id) async {
    await todos.doc(id).delete();
  }
}
