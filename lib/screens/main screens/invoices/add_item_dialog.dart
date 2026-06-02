import 'package:flutter/material.dart';
import 'package:grad_project/models/invoice_item.dart';

class _AddItemDialog extends StatefulWidget {
  final Function(InvoiceItem) onAdd;

  const _AddItemDialog({required this.onAdd});

  @override
  State<_AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<_AddItemDialog> {
  final nameCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();
  final priceCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Item"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameCtrl,
            decoration: InputDecoration(labelText: "Item name"),
          ),
          TextField(
            controller: qtyCtrl,
            decoration: InputDecoration(labelText: "Quantity"),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: priceCtrl,
            decoration: InputDecoration(labelText: "Unit price"),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            final item = InvoiceItem(
              name: nameCtrl.text,
              quantity: int.parse(qtyCtrl.text),
              price: double.parse(priceCtrl.text),
            );
            widget.onAdd(item);
            Navigator.pop(context);
          },
          child: Text("Add"),
        ),
      ],
    );
  }
}
