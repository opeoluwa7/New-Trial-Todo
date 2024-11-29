//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/components/my_dialog_box.dart';
import 'package:myapp/components/my_list_tile.dart';
import 'package:myapp/providers/auth_provider.dart';
//import 'package:myapp/model/todo_model.dart';
//import 'package:myapp/model/todo_model.dart';
//import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/providers/db_provider.dart';
//import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DbProvider dbProvider = DbProvider();
  final BaseAuth baseAuth = BaseAuth();
  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
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
                    PopupMenuItem(
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Home',
                            style: TextStyle(color: Colors.grey[900]),
                          )),
                    ),
                    PopupMenuItem(
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.popAndPushNamed(context, '/settings');
                          },
                          child: Text(
                            'Profile',
                            style: TextStyle(color: Colors.grey[900]),
                          )),
                    ),
                    PopupMenuItem(
                      child: TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await baseAuth.signOut();
                          },
                          child: Text(
                            'Log Out',
                            style: TextStyle(color: Colors.grey[900]),
                          )),
                    ),
                  ])
        ],
      ),
      body: StreamBuilder(
          stream: dbProvider.fetchTodos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (snapshot.hasData) {
              List tasks = snapshot.data!.docs;

              List incompletedTasks =
                  tasks.where((task) => task['isCompleted'] == false).toList();

              List completedTasks =
                  tasks.where((task) => task['isCompleted'] == true).toList();

              return ListView(
                children: [
                  if (incompletedTasks.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Incompleted Tasks'),
                    ),
                    ...incompletedTasks.map((task) {
                      return MyListTile(
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
                      return MyListTile(
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
          }),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey[900],
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => MyDialogBox(
                      controller: titleController,
                    ));
          },
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white, size: 32)),
    );
  }
}
