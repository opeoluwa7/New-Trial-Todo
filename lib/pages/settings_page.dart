import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/components/delete_dialog.dart';
import 'package:myapp/components/my_elevated_button.dart';
import 'package:myapp/components/my_list_tile.dart';
import 'package:myapp/model/user_model.dart';
import 'package:myapp/providers/db_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: const SettingsBody(),
    );
  }
}

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: const CustomAppBar(),
        body: const FunctionBody(),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class FunctionBody extends StatefulWidget {
  const FunctionBody({super.key});

  @override
  State<FunctionBody> createState() => _FunctionBodyState();
}

class _FunctionBodyState extends State<FunctionBody> {
  final currentUser = FirebaseAuth.instance.currentUser;
  late TextEditingController usernameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return currentUser == null
        ? const Center(
            child: Text('No authenticated user found'),
          )
        : FutureBuilder(
            future: context.read<DbProvider>().fetchUserData(currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error loading data: ${snapshot.error}'),
                );
              }
              if (snapshot.hasData) {
                debugPrint('Fetching document with ID: ${currentUser!.uid}');
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
                                      await context
                                          .read<DbProvider>()
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
                                        builder: (context) => DeleteDialog(
                                              id: id,
                                            ));
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
          );
  }
}
