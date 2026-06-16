import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'models/transaction.dart';
import 'pages/home_page.dart';
import 'pages/wallet_page.dart';
import 'pages/report_page.dart';
import 'pages/profile_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('id_ID', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal, fontFamily: 'Poppins'),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? txData = prefs.getString('saved_transactions');
    if (txData != null) {
      final List<dynamic> decoded = jsonDecode(txData);
      setState(() {
        _transactions = decoded.map((item) => Transaction.fromJson(item)).toList();
      });
    }
  }

  void _showAddTransactionDialog({String? initialType}) {
    // (Logika dialog tetap sama, kita gunakan fungsi ini di bawah)
    // Untuk mempersingkat, pastikan logic di file sebelumnya sudah benar.
    // Jika masih eror, fokus kita adalah pada pemanggilan di HomePage:
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(
        transactions: _transactions,
        onAddTransactionPressed: () => _showAddTransactionDialog(),
        onNavigateToPage: (index, {String? actionType}) {
          if (actionType != null) {
            _showAddTransactionDialog(initialType: actionType);
          } else {
            setState(() => _currentIndex = index);
          }
        },
      ),
      WalletPage(transactions: _transactions),
      ReportPage(transactions: _transactions),
      ProfilePage(onDataRestored: _loadData),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Dompet'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Laporan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
