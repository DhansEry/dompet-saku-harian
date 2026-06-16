class Transaction {
  final String id;
  final String title;
  final double amount;
  final String type; // 'income' atau 'expense'
  final String category;
  final String wallet;
  final DateTime date;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.wallet,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'amount': amount,
        'type': type,
        'category': category,
        'wallet': wallet,
        'date': date.toIso8601String(),
      };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json['id'],
        title: json['title'],
        amount: json['amount'].toDouble(),
        type: json['type'],
        category: json['category'],
        wallet: json['wallet'],
        date: DateTime.parse(json['date']),
      );
}
