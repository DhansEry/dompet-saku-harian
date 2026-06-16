import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class ReportPage extends StatelessWidget {
  final List<Transaction> transactions;

  const ReportPage({Key? key, required this.transactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    
    // Filter khusus pengeluaran saja
    final expenses = transactions.where((t) => t.type == 'expense').toList();
    double totalExpense = expenses.fold(0.0, (sum, item) => sum + item.amount);

    // Hitung total per kategori
    Map<String, double> categoryMap = {};
    for (var tx in expenses) {
      categoryMap[tx.category] = (categoryMap[tx.category] ?? 0.0) + tx.amount;
    }

    // Warna kustom untuk tiap kategori
    final List<Color> colorPalette = [Colors.red, Colors.orange, Colors.blue, Colors.purple, Colors.amber, Colors.teal];
    int colorIndex = 0;

    List<PieChartSectionData> sections = [];
    List<Widget> legendItems = [];

    categoryMap.forEach((category, amount) {
      final color = colorPalette[colorIndex % colorPalette.length];
      colorIndex++;
      final percentage = totalExpense > 0 ? (amount / totalExpense) * 100 : 0.0;

      sections.add(PieChartSectionData(
        color: color,
        value: amount,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      ));

      legendItems.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Container(width: 16, height: 16, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Expanded(child: Text(category, style: const TextStyle(fontWeight: FontWeight.w500))),
            Text(fmt.format(amount), style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ],
        ),
      ));
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Laporan Pengeluaran', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: expenses.isEmpty
          ? const Center(child: Text('Belum ada data pengeluaran untuk dianalisis.'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text('Total Pengeluaran Bulan Ini', style: TextStyle(color: Colors.grey, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text(fmt.format(totalExpense), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: PieChart(PieChartData(sections: sections, sectionsSpace: 2, centerSpaceRadius: 40)),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: legendItems,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
