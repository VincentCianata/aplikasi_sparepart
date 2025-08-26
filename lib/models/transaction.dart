class TransactionModel {
  final int id;
  final int userId;
  final List<dynamic> items;
  final double totalAmount;
  final String createdAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['user_id'],
      items: json['items'] ?? [],
      totalAmount: (json['total_amount'] as num).toDouble(),
      createdAt: json['created_at'],
    );
  }
}
