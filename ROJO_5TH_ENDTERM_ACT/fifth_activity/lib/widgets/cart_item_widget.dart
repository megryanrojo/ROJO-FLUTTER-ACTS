import 'package:flutter/material.dart';

class CartItemWidget extends StatelessWidget {
  final String productName;
  final double price;
  final int quantity;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemWidget({
    Key? key,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.onQuantityChanged,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(productName),
        subtitle: Text('Price: \$${price.toStringAsFixed(2)}'),
        trailing: SizedBox(
          width: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () => onQuantityChanged(quantity - 1),
              ),
              Text('$quantity'),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => onQuantityChanged(quantity + 1),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onRemove,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
