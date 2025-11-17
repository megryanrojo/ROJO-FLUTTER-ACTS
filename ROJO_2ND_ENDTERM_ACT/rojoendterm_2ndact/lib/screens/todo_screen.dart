import 'package:flutter/material.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController controller = TextEditingController();
  final List<String> todos = [];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Add a maintenance task',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: _add, child: const Text('Add')),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          itemCount: todos.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => Dismissible(
            key: ValueKey('todo_$index'),
            background: Container(color: Colors.redAccent),
            onDismissed: (_) => setState(() => todos.removeAt(index)),
            child: ListTile(
              leading: const Icon(Icons.check_box_outline_blank),
              title: Text(todos[index]),
            ),
          ),
        ),
      ],
    );
  }

  void _add() {
    final t = controller.text.trim();
    if (t.isEmpty) return;
    setState(() {
      todos.add(t);
      controller.clear();
    });
  }
}


