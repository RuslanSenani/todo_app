import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/task_model.dart';

class TaskListItem extends StatefulWidget {
  final Task task;
  const TaskListItem({super.key, required this.task});

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  TextEditingController _taskNameController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _taskNameController.text = widget.task.name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)]),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            setState(() {
              widget.task.isComplated = !widget.task.isComplated;
            });
          },
          child: Container(
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
            decoration: BoxDecoration(
              color: widget.task.isComplated ? Colors.green : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey, width: 0.8),
            ),
          ),
        ),
        title: widget.task.isComplated
            ? Text(
                widget.task.name,
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              )
            : TextField(
                controller: _taskNameController,
                minLines: 1,
                maxLines: null,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  if (value.length > 3) {
                    widget.task.name = value;
                  }
                },
              ),
        trailing: Text(
          DateFormat.Hm().format(
            widget.task.created,
          ),
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
