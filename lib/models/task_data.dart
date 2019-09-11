import 'package:flutter/foundation.dart';
import 'package:todoer/models/task.dart';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';

final _db = Firestore.instance;
const String DocumentID = 'My ToDo List';

class TaskData extends ChangeNotifier {
  String collectionName = '';
  List<Task> _globalTasks = [];
  bool initialSyncNeeded = true;

  initialSync(String username) {
    if (initialSyncNeeded && username != null) {
      print('DEBUG: initialSync: run initial sync for $username');

      _globalTasks.clear();
      this.collectionName = username;
      // get the initial task list from Firestore upon object construction
      _getDataFromDb();
      initialSyncNeeded = false;
    }
  }

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_globalTasks);
  }

  toggleDone(Task task) {
    task.toggleDone();
    notifyListeners();
    _writeToDb();
  }

  appendAndNotify(Task newTask) {
    _globalTasks.add(newTask);
    notifyListeners();
    _writeToDb();
  }

  deleteAndNotify(Task task) {
    _globalTasks.remove(task);
    notifyListeners();
    _writeToDb();
  }

  void _writeToDb() {
    final dbData = [];

    for (Task task in _globalTasks) {
      dbData.add({"todo_name": task.name, "todo_value": task.isDone});
    }

    _db.collection(collectionName).document(DocumentID).setData(
      {'todo_list': dbData},
    );
  }

  void _getDataFromDb() async {
    print(
        '_getDataFromDb(): trying to get data from: $collectionName/$DocumentID');

    try {
      final resultDoc =
          await _db.collection(collectionName).document(DocumentID).get();

      // print('debug: $resultDoc');
      // print('debug: ${resultDoc.data}');

      if (resultDoc.data != null) {
        // resultDoc.data is null in the first usage scenario right after the user uses the app for the first time
        for (var item in resultDoc.data['todo_list']) {
          Task task = Task(
            name: item['todo_name'],
            isDone: item['todo_value'],
          );
          _globalTasks.add(task);
        }
        notifyListeners();
      }
    } catch (err) {
      print('EXCEPTION (getDataFromDb): ${err.message}');
    }
  }
}
