//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/model/user_model.dart';
//import 'package:myapp/components/my_text_field.dart';
import 'package:myapp/providers/db_provider.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});
  final DbProvider dbProvider = DbProvider();

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //final controller = TextEditingController();
  //User? currentUser;
  //final String userId;
  final currentUser = FirebaseAuth.instance.currentUser;

  //var userId = currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    print('Current User UID: ${currentUser?.uid}');
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Account Settings',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
            onPressed: () async {
              Navigator.popAndPushNamed(context, '/home');
              //await FirebaseFirestore.instance.clearPersistence();

            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: currentUser == null
          ? const Center(
              child: Text('No authenticated user found'),
            )
          : FutureBuilder(
              future: widget.dbProvider.fetchUserData(currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading data: ${snapshot.error}'),
                  );
                }
                if (snapshot.hasData) {
                  print('Fetching document with ID: ${currentUser!.uid}');
                  final user = snapshot.data as UserModel;
                  final username = user.username;
                  final email = user.email;

                  return Scaffold(
                    body: ListView(
                      children: [
                        ListTile(
                          title: Text(username),
                        ),
                        ListTile(
                          title: Text(email),
                        ),
                      ],
                    ),
                  );
                } else {
                  debugPrint('Document does not exist');
                  // Display a loading indicator while data is loading
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
    );
  }
}
