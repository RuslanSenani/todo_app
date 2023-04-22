import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/widgets/custom_search_delegate.dart';
import 'package:todo_app/widgets/task_list_items.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTask;
  late LocalStorage _localStorage;
  @override
  void initState() {
    _localStorage = locator<LocalStorage>();
    _allTask = <Task>[];
    _getAllTaskFromDb();
    //_allTask.add(Task.create(name: "TEST", created: DateTime.now()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _showAddTaskButtonSheet();
          },
          child: Text(
            'to_do_title',
            style: TextStyle(color: Colors.black),
          ).tr(),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              _showSearchPage();
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              _showAddTaskButtonSheet();
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
                          'remove_task',
                          style: TextStyle(color: Colors.white),
                        ).tr(),
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
                    _localStorage.deleteTask(task: _oankiTask);
                    setState(() {});
                  },
                  child: TaskListItem(task: _oankiTask),
                );
              },
            )
          : Center(
              child: GestureDetector(
                onTap: () {
                  _showAddTaskButtonSheet();
                },
                child: Text(
                  'to_do_title',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.solid,
                    decorationThickness: 2,
                    decorationColor: Colors.blue,
                  ),
                ).tr(),
              ),
            ),
    );
  }

  void _showAddTaskButtonSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              autofocus: true,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(hintText: tr('add_task'), border: InputBorder.none),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                if (value.length > 3) {
                  DatePicker.showTimePicker(
                    context,
                    showSecondsColumn: false,
                    onConfirm: (time) async {
                      var yeniElaveEdilecekVezife = Task.create(name: value, created: time);

                      _allTask.insert(0, yeniElaveEdilecekVezife);
                      await _localStorage.addTask(task: yeniElaveEdilecekVezife);
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

  Future<void> _getAllTaskFromDb() async {
    _allTask = await _localStorage.getAllTask();
    setState(() {});
  }

  void _showSearchPage() async {
    await showSearch(context: context, delegate: CustomSearchDelegate(allTask: _allTask));
    _getAllTaskFromDb();
  }
}
