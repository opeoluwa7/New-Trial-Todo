//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/model/todo_model.dart';
import 'package:myapp/providers/db_provider.dart';

class MyDialogBox extends StatefulWidget {
  const MyDialogBox({
    super.key,
    required this.controller,
    this.taskId,
  });
  final TextEditingController controller;
  final String? taskId;
  @override
  State<MyDialogBox> createState() => _MyDialogBoxState();
}

class _MyDialogBoxState extends State<MyDialogBox> {
  final DbProvider dbProvider = DbProvider();

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
              onPressed: () {
                if (widget.taskId == null || widget.taskId!.isEmpty) {
                  Todo todo =
                      Todo(id: '', title: widget.controller.text.trim());
                  dbProvider.createTodo(todo);
                  Navigator.pop(context);
                  widget.controller.clear();
                } else if (widget.taskId!.isNotEmpty) {
                  Todo todo = Todo(
                      id: widget.taskId ?? '',
                      title: widget.controller.text.trim());
                  dbProvider.updateTodo(todo, widget.taskId!);
                  Navigator.pop(context);
                  widget.controller.clear();
                }
              },
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
}
