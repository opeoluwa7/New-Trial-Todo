import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myapp/components/my_dialog_box.dart';
import 'package:myapp/components/my_slidable_item.dart';
import 'package:myapp/model/todo_model.dart';
import 'package:myapp/providers/db_provider.dart';
import 'package:provider/provider.dart';

class MyCheckboxListTile extends StatefulWidget {
  const MyCheckboxListTile(
      {super.key, required this.task, required this.controller});
  final Todo task;
  final TextEditingController controller;

  @override
  State<MyCheckboxListTile> createState() => _MyCheckboxListTileState();
}

class _MyCheckboxListTileState extends State<MyCheckboxListTile> {
  bool get isChecked => widget.task.isCompleted;
  final currentUser = FirebaseAuth.instance.currentUser;

  void updateTodo(bool value) {
    final updatedTask = widget.task.copyWith(isCompleted: value);
    context
        .read<DbProvider>()
        .updateTodo(updatedTask, currentUser!.uid, updatedTask.id);
  }

  void deleteTodo() {
    Navigator.pop(context);
    context.read<DbProvider>().deleteTodo(currentUser!.uid, widget.task.id);
  }

  void deleteTodoMethod() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Are you sure you want to delete this task?'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            deleteTodo();
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.black),
                          )),
                    ],
                  )
                ],
              ),
            ));
  }

  void editDialog() {
    widget.controller.text = widget.task.title;
    showDialog(
      context: context,
      builder: (context) => MyDialogBox(
        controller: widget.controller,
        task: widget.task,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(motion: const StretchMotion(), children: [
        MySlidableItem(
            labelText: 'Edit',
            icon: Icons.edit,
            color: Colors.white,
            onPressed: (context) {
              editDialog();
            }),
        MySlidableItem(
          labelText: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onPressed: (context) {
            deleteTodoMethod();
          },
        )
      ]),
      child: CheckboxListTile(
        value: isChecked,
        onChanged: (bool? value) {
          if (value != null) {
            updateTodo(value);
          }
        },
        title: Text(widget.task.title),
      ),
    );
  }
}
