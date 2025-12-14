class RealtimeItem {
  final String id;
  final String name;
  final int quantity;
  final DateTime updatedAt;

  const RealtimeItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.updatedAt,
  });

  factory RealtimeItem.fromMap(String id, Map<dynamic, dynamic> data) {
    return RealtimeItem(
      id: id,
      name: data['name'] as String? ?? 'Item',
      quantity: (data['quantity'] as num?)?.toInt() ?? 0,
      updatedAt:
          DateTime.tryParse(data['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
}


