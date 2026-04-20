class InvoiceItem {
  final int productId;
  final String productName;
  final int quantity;
  final double price;

  InvoiceItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  double get total => quantity * price;
}
