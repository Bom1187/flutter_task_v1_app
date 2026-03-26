import 'package:flutter/material.dart';

class AddTaskUi extends StatefulWidget {
  const AddTaskUi({super.key});

  @override
  State<AddTaskUi> createState() => _AddTaskUiState();
}

class _AddTaskUiState extends State<AddTaskUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Task Na Ja V1 (Add Task)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
    );
  }
}
