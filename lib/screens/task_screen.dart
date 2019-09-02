import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoer/screens/add_task_screen.dart';
import 'package:todoer/models/task.dart';
import 'package:todoer/widgets/task_tile.dart';
import 'package:todoer/models/task_data.dart';
import 'package:todoer/widgets/constants.dart';
import 'package:todoer/widgets/user_avatar.dart';
import 'package:google_sign_in/google_sign_in.dart';

class TaskScreen extends StatefulWidget {
  static const String id = 'task_screen';
  final GoogleSignIn googleSignIn;

  TaskScreen(this.googleSignIn);

  @override
  _TaskScreenState createState() =>
      _TaskScreenState(googleSignIn: googleSignIn);
}

class _TaskScreenState extends State<TaskScreen> {
  final GoogleSignIn googleSignIn;
  _TaskScreenState({this.googleSignIn});

  Widget buildBottomSheet(BuildContext context) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        if (taskData.initialSyncNeeded && googleSignIn.currentUser != null)
          taskData.initialSync('${googleSignIn.currentUser.email}');

        return Scaffold(
          backgroundColor: Colors.lightBlueAccent,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var newTaskTitle = await showModalBottomSheet(
                context: context,
                builder: (context) => AddTaskScreen(),
              );
              if (newTaskTitle != null) {
                taskData.appendAndNotify(
                  Task(name: newTaskTitle.toString()),
                );
              }
            },
            backgroundColor: Colors.lightBlueAccent,
            child: Icon(
              Icons.add,
              size: 35.0,
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    left: 30.0, top: 60.0, right: 30.0, bottom: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        todoerLogo,
                        UserAvatar(
                            googleSignIn: googleSignIn, taskData: taskData),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'ToDoer',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50.0,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${taskData.tasks.length} Tasks',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: taskData.tasks.length,
                    itemBuilder: (context, index) {
                      Task task = taskData.tasks[index];
                      return TaskTile(
                          taskText: task.name,
                          isChecked: task.isDone,
                          toggleHandler: (newValue) {
                            taskData.toggleDone(task);
                          },
                          longPressHandler: () {
                            taskData.deleteAndNotify(task);
                          });
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
