import 'package:firebase_database/firebase_database.dart';
import '../model/task_model.dart';

// Here I'm are using firebase Realtime Database to perform CRUD Operations, because, the firestore cloud reqires Billing of firebase to work on, so I switched to Firebase RealTime Database for CRUD operations
class TaskService {
  final DatabaseReference _dbRef = FirebaseDatabase.instanceFor(
    app: FirebaseDatabase.instance.app,
    databaseURL:
        "https://task-manager-app-flutter-4daa0-default-rtdb.firebaseio.com/",
  ).ref("tasks");

  Future<void> addTask(TaskModel task) async {
    final newTaskRef = _dbRef.push();
    await newTaskRef.set({
      'id': newTaskRef.key,
      'title': task.title,
      'description': task.description,
      'date': task.date,
      'completed': task.completed,
      'priority': task.priority,
    });
  }

  // READ: Get tasks in real-time
  Stream<List<TaskModel>> getTasks() {
    return _dbRef.onValue.map((event) {
      final List<TaskModel> tasks = [];
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        data.forEach((key, value) {
          tasks.add(
            TaskModel(
              id: key,
              title: value['title'] ?? '',
              description: value['description'] ?? '',
              date: value['date'] ?? '',
              completed: value['completed'] ?? false,
              priority: value['priority'] ?? 'Medium',
            ),
          );
        });
      }
      return tasks;
    });
  }

  Future<void> toggleTaskStatus(String id, bool currentStatus) async {
    await _dbRef.child(id).update({'completed': !currentStatus});
  }

  Future<void> togglePriority(String id, String currentPriority) async {
    await _dbRef.child(id).update({
      'priority': currentPriority == 'High' ? 'Medium' : 'High',
    });
  }

  Future<void> deleteTask(String id) async {
    await _dbRef.child(id).remove();
  }
}
