//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/components/delete_dialog.dart';
import 'package:myapp/components/my_elevated_button.dart';
//import 'package:myapp/components/my_checkbox_list_tile.dart';
import 'package:myapp/components/my_list_tile.dart';
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
  late TextEditingController usernameController;
  late TextEditingController emailController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usernameController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
  }

  //var userId = currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    print('Current User UID: ${currentUser?.uid}');
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
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
                    final username = usernameController.text = user.username;
                    final email = emailController.text = user.email;
                    final id = user.id;

                    return Scaffold(
                      body: ListView(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          const Icon(
                            Icons.account_circle_rounded,
                            size: 100,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyNewListTile(
                                  header: 'Username',
                                  text: username,
                                  controller: usernameController,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                MyNewListTile(
                                  header: 'Email',
                                  text: email,
                                  controller: emailController,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    MyElevatedButton(
                                      text: 'Save Changes',
                                      color: Colors.green,
                                      onPressed: () async {
                                        UserModel updatedUser = UserModel(
                                            username: username,
                                            email: email,
                                            id: id);

                                        try {
                                          await widget.dbProvider
                                              .updateUser(updatedUser, user.id);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Changes saved successfully!')),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Failed to save changes.')),
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    MyElevatedButton(
                                      text: 'Delete Account',
                                      color: Colors.red,
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                DeleteDialog(id: id,));
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
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
      ),
    );
  }
}
