import 'package:flutter/material.dart';

void main() {
  runApp(const DompetSakuApp());
}

class DompetSakuApp extends StatelessWidget {
  const DompetSakuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dompet Saku Harian',
      theme: ThemeData(
        primaryColor: const Color(0xFF008A45),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const Center(child: Text('Dashboard Beranda', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF008A45)))),
    const Center(child: Text('History Transaksi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF008A45)))),
    const SizedBox(), 
    const Center(child: Text('Dompet Saya', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF008A45)))),
    const Center(child: Text('Profil Pengguna', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF008A45)))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex == 2 ? 0 : _currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => _tampilkanMenuCepat(context),
        backgroundColor: const Color(0xFF008A45),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home_outlined, color: _currentIndex == 0 ? const Color(0xFF008A45) : Colors.grey),
                onPressed: () => setState(() => _currentIndex = 0),
              ),
              IconButton(
                icon: Icon(Icons.receipt_long_outlined, color: _currentIndex == 1 ? const Color(0xFF008A45) : Colors.grey),
                onPressed: () => setState(() => _currentIndex = 1),
              ),
              const SizedBox(width: 40), 
              IconButton(
                icon: Icon(Icons.account_balance_wallet_outlined, color: _currentIndex == 3 ? const Color(0xFF008A45) : Colors.grey),
                onPressed: () => setState(() => _currentIndex = 3),
              ),
              IconButton(
                icon: Icon(Icons.person_outline, color: _currentIndex == 4 ? const Color(0xFF008A45) : Colors.grey),
                onPressed: () => setState(() => _currentIndex = 4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _tampilkanMenuCepat(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          height: MediaQuery.of(context).size.height * 0.35,
          child: const Center(
            child: Text(
              'Menu Cepat Terbuka!\n(Input Pemasukan / Pengeluaran / Transfer)',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500),
            ),
          ),
        );
      },
    );
  }
}
