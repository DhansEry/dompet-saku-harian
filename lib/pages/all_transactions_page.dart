import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class AllTransactionsPage extends StatelessWidget {
  final List<Transaction> transactions;

  const AllTransactionsPage({Key? key, required this.transactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Semua Aktivitas', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: transactions.isEmpty
          ? const Center(child: Text('Belum ada riwayat transaksi.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                final isIncome = tx.type == 'income';
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isIncome ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                      child: Icon(isIncome ? Icons.arrow_downward : Icons.arrow_upward, color: isIncome ? Colors.green : Colors.red),
                    ),
                    title: Text(tx.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${tx.category} • ${tx.wallet}'),
                    trailing: Text(
                      '${isIncome ? "+" : "-"} ${currencyFormatter.format(tx.amount)}',
                      style: TextStyle(color: isIncome ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
