import 'package:flutter/material.dart';
import 'package:grad_project/features/invoices/widgets/van_item_card.dart';
import 'package:grad_project/features/van_stock/models/van_stock_hive.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class VanstockSheet extends StatefulWidget {
  final List<VanStockHive> vanItems;
  final Function(VanStockHive) onSelect;

  const VanstockSheet({
    super.key,
    required this.vanItems,
    required this.onSelect,
  });

  @override
  State<VanstockSheet> createState() => _VanstockSheetState();
}

class _VanstockSheetState extends State<VanstockSheet> {
  late List<VanStockHive> filtered;

  @override
  void initState() {
    super.initState();
    filtered = widget.vanItems;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55, // starts at half screen
      minChildSize: 0.40, // can shrink
      maxChildSize: 0.90, // can expand but not full
      builder: (context, scrollController) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "Add from Vanstock",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // SEARCH BAR + BARCODE BUTTON
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search items...",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                          ),

                          onChanged: (value) {
                            setSheetState(() {
                              filtered = widget.vanItems
                                  .where(
                                    (i) => i.name.toLowerCase().contains(
                                      value.toLowerCase(),
                                    ),
                                  )
                                  .toList();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () async {
                          final scanned =
                              await Navigator.of(
                                context,
                                rootNavigator: true,
                              ).push(
                                MaterialPageRoute(
                                  builder: (_) => const BarcodeScannerScreen(),
                                ),
                              );

                          // ignore: avoid_print
                          print("Scanned Barcode: $scanned");

                          if (scanned != null) {
                            setSheetState(() {
                              filtered = widget.vanItems
                                  .where((i) => i.barcode == scanned)
                                  .toList();
                            });
                          }
                        },

                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: BoxBorder.all(color: Colors.grey.shade300),
                          ),
                          child: Icon(Icons.qr_code_scanner, size: 28),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ITEM LIST
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: filtered.length,
                      itemBuilder: (_, index) {
                        final item = filtered[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: VanItemCard(
                            item: item,
                            onTap: () => widget.onSelect(item),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class BarcodeScannerScreen extends StatelessWidget {
  const BarcodeScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool hasScanned = false;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Scan Barcode"),
      ),
      body: Stack(
        children: [
          // CAMERA
          MobileScanner(
            onDetect: (capture) {
              // Prevent multiple detections
              if (hasScanned) return;

              final barcode = capture.barcodes.first;
              final value = barcode.rawValue;

              if (value != null) {
                hasScanned = true;

                Navigator.pop(context, value);
              }
            },
          ),

          // DARK OVERLAY
          Container(color: Colors.black.withValues(alpha: 0.4)),

          // CENTER SCAN WINDOW
          Center(
            child: Container(
              width: 260,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white, width: 3),
              ),
            ),
          ),

          // LASER LINE
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(width: 240, height: 2, color: Colors.redAccent),
            ),
          ),

          // INSTRUCTIONS
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Text(
              "Align the barcode inside the frame",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
