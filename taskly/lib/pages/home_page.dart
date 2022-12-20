import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskly/models/task.dart';

class MyWidget extends StatefulWidget {
  // MyWidget();
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late double _deviceWidth, _deviceHeight;
  String? _newTaskContent;
  Box? _box;

  _MyWidgetState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    // print("Input value: $_newTaskContent");

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _deviceHeight * 0.15,
        title: const Text(
          'Taskly!',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: _TaskView(),
      floatingActionButton: _addTaskButton(),
    );
  }

  Widget _TaskView() {
    // Hive.openBox('tasks');
    return FutureBuilder(
      future: Hive.openBox('tasks'),
      /*Future.delayed(Duration(seconds: 2))*/
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _box = snapshot.data;
          return _taskList();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _taskList() {
    List tasks = _box!.values.toList();
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        var task = Task.fromMap(tasks[index]);
        return ListTile(
          title: Text(
            task.content,
            style: TextStyle(
                decoration: task.done ? TextDecoration.lineThrough : null),
          ),
          subtitle: Text(task.timestamp.toString()),
          trailing: Icon(
            task.done
                ? Icons.check_box_outlined
                : Icons.check_box_outline_blank,
            color: Colors.red,
          ),
          onTap: () {
            task.done = !task.done;
            _box!.putAt(index, task.toMap());
            setState(() {});
          },
          onLongPress: () {
            _box!.deleteAt(index);
            setState(() {});
            
          },
        );
      },
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: _displayTaskpop,
      child: const Icon(Icons.add),
    );
  }

  void _displayTaskpop() {
    showDialog(
        context: context,
        builder: (BuildContext _context) {
          return AlertDialog(
            title: const Text('Add new task'),
            content: TextField(
              onSubmitted: (_) {
                if (_newTaskContent != null) {
                  var task = Task(
                      content: _newTaskContent!,
                      timestamp: DateTime.now(),
                      done: false);
                  _box!.add(task.toMap());
                  setState(() {
                    _newTaskContent = null;
                    Navigator.pop(context);
                  });
                }
              },
              onChanged: (value) {
                setState(() {
                  _newTaskContent = value;
                });
              },
            ),
          );
        });
  }
}
