import 'package:flutter/material.dart';
import 'package:grad_project/features/invoices/widgets/vanstock_sheet.dart';
import 'package:grad_project/features/van_stock/models/van_stock_hive.dart';
import 'package:provider/provider.dart';

import 'package:grad_project/features/visits/models/visit_hive.dart';
import 'package:grad_project/features/invoices/models/invoice_item_hive.dart';
import 'package:grad_project/features/invoices/providers/invoice_provider.dart';
import 'package:grad_project/features/van_stock/providers/van_stock_provider.dart';
import 'package:grad_project/features/visits/providers/visit_provider.dart';

class InvoiceCreateScreen extends StatefulWidget {
  final VisitHive visit;

  const InvoiceCreateScreen({super.key, required this.visit});

  @override
  State<InvoiceCreateScreen> createState() => _InvoiceCreateScreenState();
}

class _InvoiceCreateScreenState extends State<InvoiceCreateScreen> {
  final List<InvoiceItemHive> _items = [];
  // final vanItems = context.read<VanStockProvider>().items;
  final vanItems = [
    VanStockHive(
      id: 1,
      productId: 1,
      name: "دارك سادة 85 غرام",
      sku: "BEV-0041",
      barcode: "barcode",
      price: 100,
      unitOfMeasure: "unitOfMeasure",
      minStockLevel: 1,
      quantity: 12,
    ),
    VanStockHive(
      id: 1,
      productId: 2,
      name: "ميلك لوز 85 غرام",
      sku: "BEV-0012",
      barcode: "barcode2",
      price: 100,
      unitOfMeasure: "unitOfMeasure",
      minStockLevel: 1,
      quantity: 48,
    ),
  ];

  late List<VanStockHive> _tempVanStock;

  @override
  void initState() {
    super.initState();
    //
    _tempVanStock = [
      VanStockHive(
        id: 1,
        productId: 1,
        name: "دارك سادة 85 غرام",
        sku: "BEV-0041",
        barcode: "6211960061886",
        price: 100,
        unitOfMeasure: "unitOfMeasure",
        minStockLevel: 1,
        quantity: 12,
      ),
      VanStockHive(
        id: 2,
        productId: 2,
        name: "ميلك لوز 85 غرام",
        sku: "BEV-0012",
        barcode: "barcode2",
        price: 100,
        unitOfMeasure: "unitOfMeasure",
        minStockLevel: 1,
        quantity: 48,
      ),
    ];
  }

  double get total =>
      _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void _addItem() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return VanstockSheet(
          vanItems: _tempVanStock,
          onSelect: (item) => _choosePackageOrSingle(item),
        );
      },
    );
  }

  void _removeItem(int index) {
    setState(() {
      final removed = _items[index];

      // Restore quantity back into temp vanstock
      final tempItem = _tempVanStock.firstWhere((i) => i.id == removed.itemId);
      tempItem.quantity += removed.quantity;

      // Remove from invoice list
      _items.removeAt(index);
    });
  }

  void _choosePackageOrSingle(VanStockHive item) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.inventory_2_outlined),
                title: Text("Whole Package"),
                subtitle: Text("Select number of packages"),
                onTap: () => Navigator.pop(context, "package"),
              ),
              ListTile(
                leading: Icon(Icons.numbers),
                title: Text("Single Pieces"),
                subtitle: Text("Choose quantity (1,2,3...)"),
                onTap: () => Navigator.pop(context, "single"),
              ),
            ],
          ),
        );
      },
    );

    if (choice == "package") {
      _choosePackageQuantity(item);
    } else if (choice == "single") {
      _choosePieceQuantity(item);
    }
  }

  void _choosePackageQuantity(VanStockHive item) async {
    int qty = 1; // default

    final selected = await showDialog<int>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Packages of ${item.name}"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // MINUS BUTTON
                IconButton(
                  icon: Icon(Icons.remove_circle_outline, size: 32),
                  onPressed: qty > 1 ? () => setState(() => qty--) : null,
                ),

                // QUANTITY DISPLAY
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    qty.toString(),
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),

                // PLUS BUTTON
                IconButton(
                  icon: Icon(Icons.add_circle_outline, size: 32),
                  onPressed: qty < item.quantity
                      ? () => setState(() => qty++)
                      : null,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, qty),
                child: Text("Add"),
              ),
            ],
          );
        },
      ),
    );

    if (selected != null) {
      _addInvoiceItem(item, selected);
    }
  }

  void _choosePieceQuantity(VanStockHive item) async {
    int qty = 1; // default

    final selected = await showDialog<int>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Pieces of ${item.name}"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // MINUS BUTTON
                IconButton(
                  icon: Icon(Icons.remove_circle_outline, size: 32),
                  onPressed: qty > 1 ? () => setState(() => qty--) : null,
                ),

                // QUANTITY DISPLAY
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    qty.toString(),
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),

                // PLUS BUTTON
                IconButton(
                  icon: Icon(Icons.add_circle_outline, size: 32),
                  onPressed: qty < item.quantity
                      ? () => setState(() => qty++)
                      : null,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, qty),
                child: Text("Add"),
              ),
            ],
          );
        },
      ),
    );

    if (selected != null) {
      _addInvoiceItem(item, selected);
    }
  }

  void _addInvoiceItem(VanStockHive item, int qty) {
    setState(() {
      _items.add(
        InvoiceItemHive(
          itemId: item.id,
          name: item.name,
          price: item.price,
          quantity: qty,
        ),
      );

      final tempItem = _tempVanStock.firstWhere((i) => i.id == item.id);
      tempItem.quantity -= qty;
    });

    Navigator.pop(context); // close bottom sheet
  }

  Future<void> _saveInvoice() async {
    final invoiceProvider = context.read<InvoiceProvider>();
    final visitProvider = context.read<VisitProvider>();
    final vanStockProvider = context.read<VanStockProvider>();

    // 1. Create invoice
    final invoiceId = await invoiceProvider.addInvoice(
      customerId: widget.visit.customerId,
      visitId: widget.visit.id,
      items: _items,
    );

    // 2. Deduct stock
    for (final item in _items) {
      await vanStockProvider.deduct(item.itemId, item.quantity);
    }

    // 3. Attach invoice to visit
    visitProvider.attachInvoice(invoiceId);

    // 4. Return invoiceId to VisitSummaryScreen
    if (!mounted) return;
    Navigator.pop(context, invoiceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: AppBar(
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "New Invoice",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  "Thursday, Oct 12 • Central Route",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Items",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),

                TextButton(
                  onPressed: _addItem,
                  child: Row(
                    children: [
                      Icon(
                        Icons.library_add_outlined,
                        color: Colors.deepPurple.shade400,
                        size: 22,
                      ),
                      SizedBox(width: 5),

                      Text(
                        "Add Item",
                        style: TextStyle(
                          color: Colors.deepPurple.shade400,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _items.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        "No items added yet.",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (_, index) {
                        final item = _items[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: BoxBorder.all(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            child: ListTile(
                              title: Text(item.name),
                              subtitle: Text(
                                "${item.quantity} × ${item.price}",
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    (item.price * item.quantity)
                                        .toStringAsFixed(2),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _removeItem(index),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: BoxBorder.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Subtotal",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        "\$${total.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Discount",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        "\$0.00",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "VAT (5%)",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        "\"allready included\"",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: Colors.black12, thickness: 1),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Grand Total",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "\$${total.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: _items.isEmpty ? null : _saveInvoice,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Finish & Save Invoice",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
