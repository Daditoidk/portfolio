import 'package:flutter/material.dart';

// Demo 6: Task Manager App
class TaskManagerDemo extends StatefulWidget {
  const TaskManagerDemo({super.key});

  @override
  State<TaskManagerDemo> createState() => _TaskManagerDemoState();
}

class _TaskManagerDemoState extends State<TaskManagerDemo> {
  final List<Map<String, dynamic>> tasks = [
    {'title': 'Reunión con equipo', 'completed': false, 'priority': 'high'},
    {'title': 'Revisar código', 'completed': true, 'priority': 'medium'},
    {'title': 'Preparar presentación', 'completed': false, 'priority': 'low'},
    {'title': 'Enviar emails', 'completed': false, 'priority': 'high'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF27AE60),
        elevation: 0,
        title: const Text(
          'TaskApp',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF27AE60),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  '${tasks.where((task) => task['completed']).length}/${tasks.length} tareas completadas',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Checkbox(
                      value: task['completed'],
                      onChanged: (value) {
                        setState(() {
                          task['completed'] = value;
                        });
                      },
                      activeColor: const Color(0xFF27AE60),
                    ),
                    title: Text(
                      task['title'],
                      style: TextStyle(
                        decoration: task['completed'] ? TextDecoration.lineThrough : null,
                        color: task['completed'] ? Colors.grey : Colors.black,
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(task['priority']),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        task['priority'].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return const Color(0xFFE74C3C);
      case 'medium':
        return const Color(0xFFF39C12);
      case 'low':
        return const Color(0xFF27AE60);
      default:
        return Colors.grey;
    }
  }
} 