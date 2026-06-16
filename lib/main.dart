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
      title: 'Dompet Saku Harian',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Poppins',
      ),
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

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_transactions.map((t) => t.toJson()).toList());
    await prefs.setString('saved_transactions', encoded);
  }

  void _showAddTransactionDialog({String? initialType}) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String selectedType = initialType ?? 'expense';
    String selectedCategory = selectedType == 'income' ? 'Gaji' : 'Makanan';
    String selectedWallet = 'Cash';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tambah Transaksi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text('Pengeluaran')),
                            selected: selectedType == 'expense',
                            selectedColor: Colors.red.withOpacity(0.2),
                            onSelected: (val) {
                              setModalState(() {
                                selectedType = 'expense';
                                selectedCategory = 'Makanan';
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text('Pemasukan')),
                            selected: selectedType == 'income',
                            selectedColor: Colors.green.withOpacity(0.2),
                            onSelected: (val) {
                              setModalState(() {
                                selectedType = 'income';
                                selectedCategory = 'Gaji';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Judul / Catatan')),
                    TextField(controller: amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Jumlah Uang (Rp)')),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(labelText: 'Kategori'),
                      items: (selectedType == 'income' 
                        ? ['Gaji', 'Bonus', 'Usaha', 'Lainnya']
                        : ['Makanan', 'Transportasi', 'Belanja', 'Hiburan', 'Tagihan', 'Lainnya']
                      ).map((String val) {
                        return DropdownMenuItem<String>(value: val, child: Text(val));
                      }).toList(),
                      onChanged: (val) => setModalState(() => selectedCategory = val!),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedWallet,
                      decoration: const InputDecoration(labelText: 'Sumber Dompet'),
                      items: ['Cash', 'BCA', 'BRI', 'OVO', 'DANA'].map((String val) {
                        return DropdownMenuItem<String>(value: val, child: Text(val));
                      }).toList(),
                      onChanged: (val) => setModalState(() => selectedWallet = val!),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D9488), padding: const EdgeInsets.all(16)),
                        onPressed: () {
                          if (titleController.text.isEmpty || amountController.text.isEmpty) return;
                          final double? enteredAmount = double.tryParse(amountController.text);
                          if (enteredAmount == null || enteredAmount <= 0) return;

                          setState(() {
                            _transactions.insert(
                              0,
                              Transaction(
                                id: DateTime.now().toString(),
                                title: titleController.text,
                                amount: enteredAmount,
                                type: selectedType,
                                category: selectedCategory,
                                wallet: selectedWallet,
                                date: DateTime.now(),
                              ),
                            );
                          });
                          _saveData();
                          Navigator.pop(context);
                        },
                        child: const Text('Simpan Transaksi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(
        transactions: _transactions, 
        onAddTransactionPressed: _showAddTransactionDialog,
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
      ProfilePage(onDataRestored: _loadData), // Callback fungsi refresh data setelah di-restore
    ];

    return Scaffold(
      body: pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0D9488),
        onPressed: () => _showAddTransactionDialog(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0D9488),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Dompet'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Laporan'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}
