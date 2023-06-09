import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/helper/translation_helper.dart';
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
          child: const Text(
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
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              _showAddTaskButtonSheet();
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: _allTask.isNotEmpty
          ? ListView.builder(
              itemCount: _allTask.length,
              itemBuilder: (context, index) {
                var oankiTask = _allTask[index];
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'remove_task',
                          style: TextStyle(color: Colors.white),
                        ).tr(),
                        const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),
                  key: Key(oankiTask.id),
                  onDismissed: (direction) {
                    _allTask.removeAt(index);
                    _localStorage.deleteTask(task: oankiTask);
                    setState(() {});
                  },
                  child: TaskListItem(task: oankiTask),
                );
              },
            )
          : Center(
              child: GestureDetector(
                onTap: () {
                  _showAddTaskButtonSheet();
                },
                child: const Text(
                  'empty_task_list',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
              style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(hintText: 'add_task'.tr(), border: InputBorder.none),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                if (value.length > 3) {
                  DatePicker.showTimePicker(
                    locale: TranslationHelper.getDeviceLanguage(context),
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
