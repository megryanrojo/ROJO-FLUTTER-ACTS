import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/chat_message.dart';
import '../models/realtime_item.dart';

class RealtimeDatabaseService {
  RealtimeDatabaseService._();

  static final RealtimeDatabaseService _instance = RealtimeDatabaseService._();
  factory RealtimeDatabaseService() => _instance;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DatabaseReference get _inventoryRef => _database.ref('inventory/items');
  DatabaseReference get _chatRef => _database.ref('chat/messages');

  Stream<List<RealtimeItem>> inventoryStream() {
    return _inventoryRef.onValue.map((event) {
      final value = event.snapshot.value;
      if (value == null) return <RealtimeItem>[];
      final map = Map<dynamic, dynamic>.from(value as Map);
      final items = map.entries
          .map(
            (entry) => RealtimeItem.fromMap(
              entry.key as String,
              Map<dynamic, dynamic>.from(entry.value as Map),
            ),
          )
          .toList();
      items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return items;
    });
  }

  Future<void> addInventoryItem(String name, int quantity) async {
    final key = _inventoryRef.push().key;
    if (key == null) return;
    await _inventoryRef
        .child(key)
        .set(
          RealtimeItem(
            id: key,
            name: name,
            quantity: quantity,
            updatedAt: DateTime.now(),
          ).toMap(),
        );
  }

  Future<void> updateInventoryQuantity(String id, int quantity) async {
    await _inventoryRef.child(id).update({
      'quantity': quantity,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> deleteInventoryItem(String id) =>
      _inventoryRef.child(id).remove();

  Stream<List<ChatMessage>> chatStream({int limit = 50}) {
    return _chatRef.orderByChild('timestamp').limitToLast(limit).onValue.map((
      event,
    ) {
      final value = event.snapshot.value;
      if (value == null) return <ChatMessage>[];
      final map = Map<dynamic, dynamic>.from(value as Map);
      final messages = map.entries
          .map(
            (entry) => ChatMessage.fromMap(
              entry.key as String,
              Map<dynamic, dynamic>.from(entry.value as Map),
            ),
          )
          .toList();
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return messages;
    });
  }

  Future<void> sendChatMessage(String text) async {
    final key = _chatRef.push().key;
    if (key == null) return;
    final sender =
        _auth.currentUser?.email ?? _auth.currentUser?.displayName ?? 'Guest';
    await _chatRef
        .child(key)
        .set(
          ChatMessage(
            id: key,
            text: text,
            sender: sender,
            timestamp: DateTime.now(),
          ).toMap(),
        );
  }
}
