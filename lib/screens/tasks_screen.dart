import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/task_service.dart';
import '../model/task_model.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = TaskService();

    return Scaffold(
      backgroundColor: const Color(0xFF131416),

      appBar: AppBar(
        title: const Text(
          "Tasks",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [Padding(padding: const EdgeInsets.only(right: 16.0))],
      ),
      body: StreamBuilder<List<TaskModel>>(
        stream: service.getTasks(), // This now listens to your RTDB URL
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          }

          final allTasks = snapshot.data ?? [];
          final pendingTasks = allTasks.where((t) => !t.completed).toList();
          final completedTasks = allTasks.where((t) => t.completed).toList();

          if (allTasks.isEmpty) {
            return _buildEmptyState(
              icon: Icons.task_alt,
              title: "No tasks yet",
              subtitle:
                  "Add your to-dos and keep track of them across Our Workspace",
            );
          }

          if (pendingTasks.isEmpty) {
            return Column(
              children: [
                Expanded(
                  child: _buildEmptyState(
                    icon: Icons.check_circle_outline,
                    title: "All tasks completed",
                    subtitle: "Nice work!",
                  ),
                ),
                _buildCompletedSection(completedTasks, service),
              ],
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              const SizedBox(height: 10),

              ...pendingTasks.map((task) => _buildTaskItem(task, service)),
              if (completedTasks.isNotEmpty)
                _buildCompletedSection(completedTasks, service),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTaskItem(TaskModel task, TaskService service) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(
              Icons.circle_outlined,
              color: Colors.white70,
              size: 28,
            ),

            onPressed: () => service.toggleTaskStatus(task.id, task.completed),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text(
                  task.title,

                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),

                if (task.description.isNotEmpty)
                  Text(
                    task.description,
                    style: const TextStyle(color: Colors.white60, fontSize: 14),
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.white38,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(task.date),
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              task.priority == 'High' ? Icons.star : Icons.star_border,
              color: task.priority == 'High' ? Colors.blue : Colors.white38,
            ),
            onPressed: () => service.togglePriority(task.id, task.priority),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedSection(
    List<TaskModel> completed,
    TaskService service,
  ) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          "Completed (${completed.length})",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        children: completed
            .map(
              (task) => ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.check, color: Colors.blue),
                  onPressed: () =>
                      service.toggleTaskStatus(task.id, task.completed),
                ),
                title: Text(
                  task.title,
                  style: const TextStyle(
                    color: Colors.white38,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                  onPressed: () => service.deleteTask(task.id),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 120, color: Colors.blue.withOpacity(0.8)),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      DateTime dt = DateTime.parse(dateStr);
      return DateFormat('EEE, d MMM').format(dt);
    } catch (e) {
      return dateStr;
    }
  }
}
