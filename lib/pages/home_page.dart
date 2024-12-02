import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/components/my_dialog_box.dart';
import 'package:myapp/components/my_checkbox_list_tile.dart';
import 'package:myapp/model/todo_model.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/providers/db_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _titleController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: const CustomAppBar(),
        body: const HomePageBody(),
        floatingActionButton: MyFAB(
          controller: _titleController,
        ),
      ),
    );
  }
}

class MyFAB extends StatelessWidget {
  const MyFAB({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: Colors.grey[900],
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => MyDialogBox(
                    controller: controller,
                    task: Todo(id: '', title: ''),
                  ));
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32));
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    void signUserOut(BuildContext context) {
      Navigator.pop(context);
      context.read<BaseAuth>().signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }

    void moveToSettings(context) {
      Navigator.pop(context);
      Navigator.popAndPushNamed(context, '/settings');
    }

    return AppBar(
      backgroundColor: Colors.grey[900],
      automaticallyImplyLeading: false,
      title: const Text(
        'Home Page',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        PopupMenuButton(
            itemBuilder: (context) => [
              //I removed the home popupitem because I am using a focus scope to achive that same result
                  PopupMenuItem(
                    child: TextButton(
                        onPressed: () => moveToSettings(context),
                        child: Text(
                          'Profile',
                          style: TextStyle(color: Colors.grey[900]),
                        )),
                  ),
                  PopupMenuItem(
                    child: TextButton(
                        onPressed: () => signUserOut(context),
                        child: Text(
                          'Log Out',
                          style: TextStyle(color: Colors.grey[900]),
                        )),
                  ),
                ])
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  final titleController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: context.watch<DbProvider>().fetchTodos(currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            List<Todo> tasks = snapshot.data!.docs.map((doc) {
              return Todo.fromMap(doc.data() as Map<String, dynamic>);
            }).toList();

            List incompletedTasks =
                tasks.where((task) => !task.isCompleted).toList();

            List completedTasks =
                tasks.where((task) => task.isCompleted).toList();

            return ListView(
              children: [
                if (incompletedTasks.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Incompleted Tasks'),
                  ),
                  ...incompletedTasks.map((task) {
                    return MyCheckboxListTile(
                      task: task,
                      controller: titleController,
                    );
                  })
                ],
                Divider(
                  thickness: 1,
                  color: Colors.grey[500],
                ),
                if (completedTasks.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Completed Tasks'),
                  ),
                  ...completedTasks.map((task) {
                    return MyCheckboxListTile(
                      task: task,
                      controller: titleController,
                    );
                  })
                ]
              ],
            );
          } else {
            return const Center(
              child: Text('No Tasks yet'),
            );
          }
        });
  }
}
