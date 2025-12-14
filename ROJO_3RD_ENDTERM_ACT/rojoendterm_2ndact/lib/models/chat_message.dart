class ChatMessage {
  final String id;
  final String text;
  final String sender;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
  });

  factory ChatMessage.fromMap(String id, Map<dynamic, dynamic> data) {
    return ChatMessage(
      id: id,
      text: data['text'] as String? ?? '',
      sender: data['sender'] as String? ?? 'Anonymous',
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        (data['timestamp'] as num?)?.toInt() ??
            DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'sender': sender,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }
}


