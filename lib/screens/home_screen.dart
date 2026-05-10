import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/task_model.dart';
import '../services/task_service.dart';
import '../services/auth_service.dart';
import 'tasks_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _selectedCategory = 'All';
  final List<Widget> _pages = [const TasksScreen(), const ProfileScreen()];

  // Updated REST API Integration: Using a working Public API
  Future<Map<String, String>> _fetchQuote() async {
    try {
      // Using FreeAPI mirror as quotable.io is often down
      final response = await http.get(
        Uri.parse('https://api.freeapi.app/api/v1/public/quotes/quote/random'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Mapping the specific JSON structure of this API
        return {
          'content': data['data']['content'] ?? 'Stay focused!',
          'author': data['data']['author'] ?? 'Unknown',
        };
      }
    } catch (e) {
      debugPrint("API Error: $e");
    }
    return {'content': 'Keep pushing forward!', 'author': 'Motivation'};
  }

  void _showAddTaskSheet(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final TaskService taskService = TaskService();

    bool showDetails = false;
    bool isStarred = false;
    DateTime? selectedDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 15,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleController,
                    autofocus: true,
                    onChanged: (val) => setModalState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'New task',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  if (showDetails)
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(
                        hintText: 'Add details',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  if (selectedDate != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Chip(
                        label: Text(
                          DateFormat('EEE, MMM d').format(selectedDate!),
                        ),
                        onDeleted: () =>
                            setModalState(() => selectedDate = null),
                        deleteIcon: const Icon(Icons.close, size: 18),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.sort,
                          color: showDetails ? Colors.blue : Colors.grey,
                        ),
                        onPressed: () =>
                            setModalState(() => showDetails = !showDetails),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.blue,
                        ),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null) {
                            setModalState(() => selectedDate = picked);
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          isStarred ? Icons.star : Icons.star_border,
                          color: isStarred ? Colors.orange : Colors.blue,
                        ),
                        onPressed: () =>
                            setModalState(() => isStarred = !isStarred),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: titleController.text.isEmpty
                            ? null
                            : () async {
                                final newTask = TaskModel(
                                  id: '',
                                  title: titleController.text,
                                  description: descController.text,
                                  date:
                                      selectedDate?.toString() ??
                                      DateTime.now().toString(),
                                  completed: false,
                                  priority: isStarred ? 'High' : 'Medium',
                                );
                                await taskService.addTask(newTask);
                                if (context.mounted) Navigator.pop(context);
                              },
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: titleController.text.isEmpty
                                ? Colors.grey
                                : Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName = AuthService().user?.displayName?.split(' ')[0] ?? 'User';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _currentIndex == 1
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                "Hello, $userName 👋",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search, color: Colors.black54),
                ),
              ],
            ),
      body: Column(
        children: [
          if (_currentIndex == 0) ...[
            // REST API Integration: Displaying the Quote Header
            FutureBuilder<Map<String, String>>(
              future: _fetchQuote(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: LinearProgressIndicator(
                      minHeight: 2,
                    ), // Loading indicator requirement
                  );
                }
                final quote = snapshot.data?['content'] ?? '';
                final author = snapshot.data?['author'] ?? '';
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "\"$quote\"",
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "- $author",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: ['All', 'Work', 'Personal', 'Starred'].map((
                  category,
                ) {
                  bool isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      selectedColor: Colors.blue.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.blue : Colors.black54,
                      ),
                      onSelected: (val) =>
                          setState(() => _selectedCategory = category),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
          Expanded(child: _pages[_currentIndex]),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskSheet(context),
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.list_alt_rounded,
                color: _currentIndex == 0 ? Colors.blue : Colors.grey,
              ),
              onPressed: () => setState(() => _currentIndex = 0),
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: Icon(
                Icons.person_outline_rounded,
                color: _currentIndex == 1 ? Colors.blue : Colors.grey,
              ),
              onPressed: () => setState(() => _currentIndex = 1),
            ),
          ],
        ),
      ),
    );
  }
}
