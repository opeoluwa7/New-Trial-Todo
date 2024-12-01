import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myapp/components/my_dialog_box.dart';
import 'package:myapp/components/my_slidable_item.dart';
import 'package:myapp/model/todo_model.dart';
import 'package:myapp/providers/db_provider.dart';
import 'package:provider/provider.dart';

class MyListTile extends StatefulWidget {
  const MyListTile({super.key, required this.task, required this.controller});
  final Todo task;
  final TextEditingController controller;

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  bool get isChecked => widget.task.isCompleted;
  final currentUser = FirebaseAuth.instance.currentUser;

  void updateTodo(bool value) {
    final updatedTask = widget.task.copyWith(isCompleted: value);
    context
        .read<DbProvider>()
        .updateTodo(updatedTask, currentUser!.uid, updatedTask.id);
  }

  void deleteTodo() {
    context.read<DbProvider>().deleteTodo(currentUser!.uid, widget.task.id);
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
            deleteTodo();
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
