import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todo_app/models/task_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTask;
  @override
  void initState() {
    _allTask = <Task>[];
    _allTask.add(Task.create(name: "TEST", created: DateTime.now()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _showAddTaskButtonSheet(context);
          },
          child: Text(
            'Bu Gün Nə Edəcəksən ?',
            style: TextStyle(color: Colors.black),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              _showAddTaskButtonSheet(context);
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: _allTask.isNotEmpty
          ? ListView.builder(
              itemCount: _allTask.length,
              itemBuilder: (context, index) {
                var _oankiTask = _allTask[index];
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Bu Vəzifəni Silirsiz',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                  ),
                  key: Key(_oankiTask.id),
                  onDismissed: (direction) {
                    _allTask.removeAt(index);
                    setState(() {});
                  },
                  child: ListTile(
                    title: Text(_oankiTask.name + " " + _oankiTask.id),
                    subtitle: Text(_oankiTask.created.toString()),
                  ),
                );
              },
            )
          : Center(
              child: GestureDetector(
                onTap: () {
                  _showAddTaskButtonSheet(context);
                },
                child: Text(
                  'Vəzifə Əlavə Et',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.solid,
                    decorationThickness: 2,
                    decorationColor: Colors.blue,
                  ),
                ),
              ),
            ),
    );
  }

  void _showAddTaskButtonSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(hintText: 'Vəzifə Nədir', border: InputBorder.none),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                if (value.length > 3) {
                  DatePicker.showTimePicker(
                    context,
                    showSecondsColumn: false,
                    onConfirm: (time) {
                      var yeniElaveEdilecekVezife = Task.create(name: value, created: time);
                      _allTask.add(yeniElaveEdilecekVezife);
                      setState(() {});
                    },
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
