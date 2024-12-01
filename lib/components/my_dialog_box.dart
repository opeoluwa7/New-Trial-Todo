import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/model/todo_model.dart';
import 'package:myapp/providers/db_provider.dart';
import 'package:provider/provider.dart';

class MyDialogBox extends StatefulWidget {
  const MyDialogBox({
    super.key,
    required this.controller,
    required this.task,
  });
  final TextEditingController controller;
  final Todo task;
  @override
  State<MyDialogBox> createState() => _MyDialogBoxState();
}

class _MyDialogBoxState extends State<MyDialogBox> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(
                controller: widget.controller,
                autofocus: true,
              ),
            ),
            IconButton(
              onPressed: addOrUpdate,
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

  void addOrUpdate() async {
    final taskTitle = widget.controller.text.trim();
    if (taskTitle.isEmpty) {
      // Show error or return early if needed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Todo text cannot be empty")),
      );
      return;
    }
    if (widget.task.id.isEmpty) {
      Todo todo = Todo(id: '', title: taskTitle);
      await context.read<DbProvider>().createTodo(todo, currentUser!.uid);
    } else {
      Todo todo = widget.task.copyWith(title: widget.controller.text.trim());
      await context
          .read<DbProvider>()
          .updateTodo(todo, currentUser!.uid, widget.task.id);
    }
    Navigator.pop(context);
    widget.controller.clear();
  }
}
