import 'package:flutter/material.dart';

class MyNewListTile extends StatelessWidget {
  const MyNewListTile({super.key, required this.text, required this.header, required this.controller});
  final String text;
  final String header;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            )),
      ],
    );
  }
}

/* Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: ListTile(
            title: Text(text),
          ),
        ));*/