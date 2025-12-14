import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../models/realtime_item.dart';
import '../services/realtime_database_service.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _inventoryName = TextEditingController();
  final _inventoryQty = TextEditingController(text: '1');
  final _chatController = TextEditingController();
  final _realtime = RealtimeDatabaseService();

  @override
  void dispose() {
    _inventoryName.dispose();
    _inventoryQty.dispose();
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: 'Realtime inventory'),
              Tab(text: 'Chat'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _InventoryTab(
                  nameController: _inventoryName,
                  qtyController: _inventoryQty,
                  service: _realtime,
                ),
                _ChatTab(controller: _chatController, service: _realtime),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InventoryTab extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController qtyController;
  final RealtimeDatabaseService service;

  const _InventoryTab({
    required this.nameController,
    required this.qtyController,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Equipment / Item',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 90,
                child: TextField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Qty',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _addItem(context),
                child: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<List<RealtimeItem>>(
              stream: service.inventoryStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = snapshot.data ?? [];
                if (items.isEmpty) {
                  return const Center(
                    child: Text('Realtime DB is empty. Add a record above.'),
                  );
                }
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Dismissible(
                      key: ValueKey(item.id),
                      background: Container(color: Colors.redAccent),
                      onDismissed: (_) => service.deleteInventoryItem(item.id),
                      child: ListTile(
                        leading: const Icon(Icons.inventory_2_outlined),
                        title: Text(item.name),
                        subtitle: Text('Last update: ${item.updatedAt}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                final qty = item.quantity - 1;
                                if (qty >= 0) {
                                  service.updateInventoryQuantity(item.id, qty);
                                }
                              },
                            ),
                            Text(item.quantity.toString()),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => service.updateInventoryQuantity(
                                item.id,
                                item.quantity + 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addItem(BuildContext context) async {
    final name = nameController.text.trim();
    final qty = int.tryParse(qtyController.text.trim());
    if (name.isEmpty || qty == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Provide a name and quantity')),
      );
      return;
    }
    await service.addInventoryItem(name, qty);
    nameController.clear();
    qtyController.text = '1';
  }
}

class _ChatTab extends StatelessWidget {
  final TextEditingController controller;
  final RealtimeDatabaseService service;

  const _ChatTab({required this.controller, required this.service});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<List<ChatMessage>>(
            stream: service.chatStream(),
            builder: (context, snapshot) {
              final messages = snapshot.data ?? [];
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.sender,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(message.text),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'Type a message…',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _sendMessage(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _sendMessage(BuildContext context) async {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    await service.sendChatMessage(text);
    controller.clear();
  }
}
