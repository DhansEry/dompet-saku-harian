import 'package:flutter/material.dart';

void main() {
  runApp(const DompetSakuApp());
}

// ==========================================
// 1. DATA MODEL (Menata Data Transaksi)
// ==========================================
class Transaksi {
  final String id;
  final String judul;
  final double jumlah;
  final String jenis; // 'pemasukan' atau 'pengeluaran'
  final String kategori;
  final DateTime tanggal;

  Transaksi({
    required this.id,
    required this.judul,
    required this.jumlah,
    required this.jenis,
    required this.kategori,
    required this.tanggal,
  });
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
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        useMaterial3: true,
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

  // Data Dummy Awal untuk Simulasi Uang Saku
  final List<Transaksi> _daftarTransaksi = [
    Transaksi(id: 't1', judul: 'Uang Saku Bulanan', jumlah: 500000, jenis: 'pemasukan', kategori: 'Saku', tanggal: DateTime.now()),
    Transaksi(id: 't2', judul: 'Beli Kopi Susu', jumlah: 25000, jenis: 'pengeluaran', kategori: 'Konsumsi', tanggal: DateTime.now()),
  ];

  // Hitung Total Saldo, Pemasukan, & Pengeluaran secara otomatis
  double get _totalPemasukan => _daftarTransaksi.where((t) => t.jenis == 'pemasukan').fold(0, (sum, item) => sum + item.jumlah);
  double get _totalPengeluaran => _daftarTransaksi.where((t) => t.jenis == 'pengeluaran').fold(0, (sum, item) => sum + item.jumlah);
  double get _totalSaldo => _totalPemasukan - _totalPengeluaran;

  // Fungsi Tambah Transaksi Baru dari Input User
  void _tambahTransaksiBaru(String judul, double jumlah, String jenis, String kategori) {
    final transaksiBaru = Transaksi(
      id: DateTime.now().toString(),
      judul: judul,
      jumlah: jumlah,
      jenis: jenis,
      kategori: kategori,
      tanggal: DateTime.now(),
    );

    setState(() {
      _daftarTransaksi.insert(0, transaksiBaru); // Masukkan ke urutan paling atas
    });
  }

  @override
  Widget build(BuildContext context) {
    // Memasukkan widget halaman ke dalam list agar navigasi bawah berfungsi
    final List<Widget> pages = [
      _buildDashboardBeranda(), // Halaman Beranda Utama
      const Center(child: Text('History Transaksi', style: TextStyle(fontSize: 18, color: Colors.grey))),
      const SizedBox(), // Spacer tombol tengah
      const Center(child: Text('Dompet Saya', style: TextStyle(fontSize: 18, color: Colors.grey))),
      const Center(child: Text('Profil Pengguna', style: TextStyle(fontSize: 18, color: Colors.grey))),
    ];

    return Scaffold(
      body: pages[_currentIndex == 2 ? 0 : _currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => _tampilkanFormInput(context),
        backgroundColor: const Color(0xFF008A45),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
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

  // ==========================================
  // 2. DASHBOARD VIEW (Tampilan Kartu Saldo & List)
  // ==========================================
  Widget _buildDashboardBeranda() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Halo, DhansEry!', style: TextStyle(fontSize: 16, color: Colors.black54)),
            const Text('Dompet Saku Harian', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF008A45))),
            const SizedBox(height: 20),

            // KARTU UTAMA: TOTAL SALDO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF008A45), Color(0xFF00B85C)]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Saldo Saku', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  Text('Rp ${_totalSaldo.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(children: [Icon(Icons.arrow_downward, color: Colors.white70, size: 16), Text(' Pemasukan', style: TextStyle(color: Colors.white70, fontSize: 12))]),
                          Text('Rp ${_totalPemasukan.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(children: [Icon(Icons.arrow_upward, color: Colors.white70, size: 16), Text(' Pengeluaran', style: TextStyle(color: Colors.white70, fontSize: 12))]),
                          Text('Rp ${_totalPengeluaran.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 25),

            // DAFTAR TRANSAKSI TERBARU
            const Text('Transaksi Terbaru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blackDE)),
            const SizedBox(height: 10),
            _daftarTransaksi.isEmpty
                ? const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('Belum ada transaksi harian.', style: TextStyle(color: Colors.grey))))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _daftarTransaksi.length,
                    itemBuilder: (context, index) {
                      final item = _daftarTransaksi[index];
                      final isPemasukan = item.jenis == 'pemasukan';
                      return Card(
                        color: Colors.white,
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isPemasukan ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                            child: Icon(isPemasukan ? Icons.add_circle_outline : Icons.remove_circle_outline, color: isPemasukan ? Colors.green : Colors.red),
                          ),
                          title: Text(item.judul, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          subtitle: Text(item.kategori, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          trailing: Text(
                            '${isPemasukan ? "+" : "-"} Rp ${item.jumlah.toStringAsFixed(0)}',
                            style: TextStyle(fontWeight: FontWeight.bold, color: isPemasukan ? Colors.green : Colors.red, fontSize: 14),
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

  // ==========================================
  // 3. INPUT FORM LOGIC (Tombol Modal Pop-up +)
  // ==========================================
  void _tampilkanFormInput(BuildContext context) {
    final judulController = TextEditingController();
    final jumlahController = TextEditingController();
    String jenisTerpilih = 'pemasukan';
    String kategoriTerpilih = 'Saku';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, top: 20, left: 20, right: 20),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tambah Catatan Keuangan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF008A45))),
                  const SizedBox(height: 15),
                  TextField(controller: judulController, decoration: const InputDecoration(labelText: 'Nama Transaksi / Keterangan', border: OutlineInputBorder())),
                  const SizedBox(height: 12),
                  TextField(controller: jumlahController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Nominal (Rp)', border: OutlineInputBorder())),
                  const SizedBox(height: 15),
                  
                  // Pilihan Jenis: Pemasukan / Pengeluaran
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ChoiceChip(
                        label: const Text('Pemasukan'),
                        selected: jenisTerpilih == 'pemasukan',
                        selectedColor: const Color(0xFFE8F5E9),
                        onSelected: (val) => setModalState(() { jenisTerpilih = 'pemasukan'; kategoriTerpilih = 'Saku'; }),
                      ),
                      ChoiceChip(
                        label: const Text('Pengeluaran'),
                        selected: jenisTerpilih == 'pengeluaran',
                        selectedColor: const Color(0xFFFFEBEE),
                        onSelected: (val) => setModalState(() { jenisTerpilih = 'pengeluaran'; kategoriTerpilih = 'Konsumsi'; }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Tombol Simpan Data Keuangan
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF008A45), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: () {
                        if (judulController.text.isEmpty || jumlahController.text.isEmpty) return;
                        final nominal = double.tryParse(jumlahController.text) ?? 0;
                        if (nominal <= 0) return;

                        // Panggil fungsi tambah utama
                        _tambahTransaksiBaru(judulController.text, nominal, jenisTerpilih, kategoriTerpilih);
                        Navigator.pop(context); // Tutup form input
                      },
                      child: const Text('Simpan Catatan', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
