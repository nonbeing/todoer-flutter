import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final String taskText;
  final bool isChecked;
  final Function toggleHandler;
  final Function longPressHandler;
  TaskTile({
    this.taskText,
    this.isChecked,
    this.toggleHandler,
    this.longPressHandler,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: longPressHandler,
      title: Text(
        taskText,
        style: TextStyle(
          decoration: isChecked ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Checkbox(
        activeColor: Colors.lightBlueAccent,
        value: isChecked,
        onChanged: toggleHandler,
      ),
    );
  }
}
