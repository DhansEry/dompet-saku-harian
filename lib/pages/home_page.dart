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
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormatter = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');
    
    double totalIncome = transactions.where((t) => t.type == 'income').fold(0.0, (sum, item) => sum + item.amount);
    double totalExpense = transactions.where((t) => t.type == 'expense').fold(0.0, (sum, item) => sum + item.amount);
    double currentBalance = totalIncome - totalExpense;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Beranda', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // [Widget Saldo di sini]
            Text(currencyFormatter.format(currentBalance)),
            const SizedBox(height: 20),
            // Menu Cepat
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(icon: const Icon(Icons.add), onPressed: () => onNavigateToPage(0, actionType: 'income')),
                IconButton(icon: const Icon(Icons.remove), onPressed: () => onNavigateToPage(0, actionType: 'expense')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
