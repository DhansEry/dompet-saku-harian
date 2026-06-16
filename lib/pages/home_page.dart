import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'all_transactions_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  final List<Transaction> transactions;
  final VoidCallback onAddTransactionPressed;
  final Function(int, {String? actionType}) onNavigateToPage;

  const HomePage({
    Key? key,
    required this.transactions,
    required this.onAddTransactionPressed,
    required this.onNavigateToPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beranda')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AllTransactionsPage(transactions: transactions)),
            );
          },
          child: const Text('Lihat Semua Transaksi'),
        ),
      ),
    );
  }
}
