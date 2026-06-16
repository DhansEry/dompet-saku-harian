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
        leading: const Icon(Icons.menu, color: Colors.black),
        title: const Text('Beranda', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0D9488),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Saldo Aktif Hari Ini', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(currencyFormatter.format(currentBalance), style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('↗ Lebih tinggi dari kemarin', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const Divider(color: Colors.white24, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(backgroundColor: Colors.white24, radius: 16, child: Icon(Icons.arrow_downward, color: Colors.white, size: 16)),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Pemasukan', style: TextStyle(color: Colors.white70, fontSize: 11)),
                              Text(currencyFormatter.format(totalIncome), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const CircleAvatar(backgroundColor: Colors.white24, radius: 16, child: Icon(Icons.arrow_upward, color: Colors.white, size: 16)),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Pengeluaran', style: TextStyle(color: Colors.white70, fontSize: 11)),
                              Text(currencyFormatter.format(totalExpense), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Menu Cepat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildMenuItem(Icons.add_circle_outline, 'Pemasukan', Colors.green, () => onNavigateToPage(0, actionType: 'income')),
                _buildMenuItem(Icons.remove_circle_outline, 'Pengeluaran', Colors.red, () => onNavigateToPage(0, actionType: 'expense')),
                _buildMenuItem(Icons.account_balance_wallet_outlined, 'Dompet', Colors.blue, () => onNavigateToPage(1)),
                _buildMenuItem(Icons.pie_chart_outline, 'Laporan', Colors.purple, () => onNavigateToPage(2)),
              ],
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Aktivitas Terbaru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllTransactionsPage(transactions: transactions)),
                    );
                  },
                  child: const Text('Lihat Semua', style: TextStyle(color: Color(0xFF0D9488))),
                ),
              ],
            ),
            transactions.isEmpty
                ? const Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text('Belum ada transaksi terbaru')))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactions.length > 5 ? 5 : transactions.length,
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
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${tx.category} • ${tx.wallet}', style: const TextStyle(fontSize: 13)),
                              const SizedBox(height: 2),
                              Text(
                                dateFormatter.format(tx.date),
                                style: const TextStyle(color: Colors.grey, fontSize: 11),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: Text(
                            '${isIncome ? "+" : "-"} ${currencyFormatter.format(tx.amount)}',
                            style: TextStyle(color: isIncome ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
