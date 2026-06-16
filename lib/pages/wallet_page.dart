import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class WalletPage extends StatelessWidget {
  final List<Transaction> transactions;

  const WalletPage({Key? key, required this.transactions}) : super(key: key);

  double _getWalletBalance(String walletName) {
    double income = transactions.where((t) => t.wallet == walletName && t.type == 'income').fold(0.0, (sum, item) => sum + item.amount);
    double expense = transactions.where((t) => t.wallet == walletName && t.type == 'expense').fold(0.0, (sum, item) => sum + item.amount);
    return income - expense;
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final wallets = ['Cash', 'BCA', 'BRI', 'OVO', 'DANA'];
    
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Dompet Saya', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: wallets.length,
        itemBuilder: (context, index) {
          final wallet = wallets[index];
          final balance = _getWalletBalance(wallet);
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF0D9488).withOpacity(0.1),
                child: const Icon(Icons.account_balance_wallet, color: Color(0xFF0D9488)),
              ),
              title: Text(wallet, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              trailing: Text(
                fmt.format(balance),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: balance >= 0 ? Colors.black : Colors.red,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
