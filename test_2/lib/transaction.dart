class Transaction {
  final DateTime? date;
  final String quantity;
  final String? pump;
  final String revenue;
  final String unitPrice;

  Transaction({
    required this.date,
    required this.quantity,
    required this.pump,
    required this.revenue,
    required this.unitPrice,
  });
}
