import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myapp/components/my_dialog_box.dart';
import 'package:myapp/components/my_slidable_item.dart';
import 'package:myapp/model/todo_model.dart';
import 'package:myapp/providers/db_provider.dart';

class MyListTile extends StatefulWidget {
  MyListTile({super.key, required this.task, required this.controller});
  final DocumentSnapshot task;
  final DbProvider dbProvider = DbProvider();
  final TextEditingController controller;

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  bool get isChecked => widget.task['isCompleted'] ?? false;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(motion: const StretchMotion(), children: [
        MySlidableItem(
          labelText: 'Edit',
            icon: Icons.edit,
            color: Colors.white,
            onPressed: (context) {
              widget.controller.text = widget.task['title'];
              showDialog(
                  context: context,
                  builder: (context) => MyDialogBox(
                        controller: widget.controller,
                        taskId: widget.task.id,
                      ));
            }),
        MySlidableItem(
          labelText: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onPressed: (context) {
            widget.dbProvider.deleteTodo(widget.task.id);
          },
        )
      ]),
      child: CheckboxListTile(
        value: isChecked,
        onChanged: (bool? value) {
          widget.dbProvider.updateTodo(
              Todo(
                id: widget.task.id,
                title: widget.task['title'],
                isCompleted: value!,
              ),
              widget.task.id);
        },
        title: Text(widget.task['title']),
      ),
    );
  }
}
