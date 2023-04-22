import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';
import 'task_list_items.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTask;
  CustomSearchDelegate({required this.allTask});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = '';
          },
          icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: const Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
        size: 24,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList =
        allTask.where((task) => task.name.toLowerCase().contains(query.toLowerCase())).toList();
    return filteredList.isNotEmpty
        ? ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              var oankiTask = filteredList[index];
              return Dismissible(
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
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
                key: Key(oankiTask.id),
                onDismissed: (direction) async {
                  filteredList.removeAt(index);
                  await locator<LocalStorage>().deleteTask(task: oankiTask);
                },
                child: TaskListItem(task: oankiTask),
              );
            },
          )
        : Center(
            child: const Text('search_not_found').tr(),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Task> filteredList =
        allTask.where((task) => task.name.toLowerCase().contains(query.toLowerCase())).toList();
    return filteredList.isNotEmpty
        ? ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              var oankiTask = filteredList[index];
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
                onDismissed: (direction) async {
                  filteredList.removeAt(index);
                  await locator<LocalStorage>().deleteTask(task: oankiTask);
                },
                child: TaskListItem(task: oankiTask),
              );
            },
          )
        :  Center(
            child: const Text('search_not_found').tr(),
          );
  }
}
