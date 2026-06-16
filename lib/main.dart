import 'package:flutter/material.dart';

void main() {
  runApp(const DompetSakuApp());
}

// ==========================================
// DATA MODEL
// ==========================================
class Transaksi {
  final String id;
  final String judul;
  final double jumlah;
  final String jenis; // 'pemasukan' atau 'pengeluaran'
  final String kategori;
  final DateTime tanggal;
  final String catatan;

  Transaksi({
    required this.id,
    required this.judul,
    required this.jumlah,
    required this.jenis,
    required this.kategori,
    required this.tanggal,
    this.catatan = 'Tidak ada catatan tambahan.',
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
        // OPSI 1 & 2: Menerapkan Font Poppins global & tema Material 3
        fontFamily: 'Poppins',
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

  final List<Transaksi> _daftarTransaksi = [
    Transaksi(id: 't1', judul: 'Uang Saku Bulanan', jumlah: 500000, jenis: 'pemasukan', kategori: 'Saku', tanggal: DateTime.now(), catatan: 'Transferan awal bulan dari orang tua.'),
    Transaksi(id: 't2', judul: 'Beli Kopi Susu', jumlah: 25000, jenis: 'pengeluaran', kategori: 'Konsumsi', tanggal: DateTime.now(), catatan: 'Kopi susu gula aren di kedai dekat rumah.'),
  ];

  double get _totalPemasukan => _daftarTransaksi.where((t) => t.jenis == 'pemasukan').fold(0, (sum, item) => sum + item.jumlah);
  double get _totalPengeluaran => _daftarTransaksi.where((t) => t.jenis == 'pengeluaran').fold(0, (sum, item) => sum + item.jumlah);
  double get _totalSaldo => _totalPemasukan - _totalPengeluaran;

  void _tambahTransaksiBaru(String judul, double jumlah, String jenis, String kategori, String catatan) {
    final transaksiBaru = Transaksi(
      id: DateTime.now().toString(),
      judul: judul,
      jumlah: jumlah,
      jenis: jenis,
      kategori: kategori,
      tanggal: DateTime.now(),
      catatan: catatan.isEmpty ? 'Tidak ada catatan tambahan.' : catatan,
    );

    setState(() {
      _daftarTransaksi.insert(0, transaksiBaru);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildDashboardBeranda(),
      const Center(child: Text('History Transaksi', style: TextStyle(color: Colors.grey))),
      const SizedBox(),
      const Center(child: Text('Dompet Saya', style: TextStyle(color: Colors.grey))),
      const Center(child: Text('Profil Pengguna', style: TextStyle(color: Colors.grey))),
    ];

    return Scaffold(
      body: pages[_currentIndex == 2 ? 0 : _currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => _tampilkanFormInput(context),
        backgroundColor: const Color(0xFF008A45),
        shape: const CircleBorder(),
        child: const Icon(Icons.add_circle, color: Colors.white, size: 32), // Menggunakan ikon yang lebih variatif
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
              IconButton(icon: Icon(Icons.grid_view_rounded, color: _currentIndex == 0 ? const Color(0xFF008A45) : Colors.grey), onPressed: () => setState(() => _currentIndex = 0)),
              IconButton(icon: Icon(Icons.account_balance_wallet_rounded, color: _currentIndex == 1 ? const Color(0xFF008A45) : Colors.grey), onPressed: () => setState(() => _currentIndex = 1)),
              const SizedBox(width: 40),
              IconButton(icon: Icon(Icons.analytics_rounded, color: _currentIndex == 3 ? const Color(0xFF008A45) : Colors.grey), onPressed: () => setState(() => _currentIndex = 3)),
              IconButton(icon: Icon(Icons.manage_accounts_rounded, color: _currentIndex == 4 ? const Color(0xFF008A45) : Colors.grey), onPressed: () => setState(() => _currentIndex = 4)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardBeranda() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Halo, DhansEry!', style: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500)),
            const Text('Dompet Saku Harian', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF008A45))),
            const SizedBox(height: 20),

            // KARTU SALDO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF008A45), Color(0xFF02A654)]),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Saldo Saku', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  Text('Rp ${_totalSaldo.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        const CircleAvatar(radius: 14, backgroundColor: Colors.white24, child: Icon(Icons.arrow_downward, color: Colors.white, size: 16)),
                        const SizedBox(width: 8),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Pemasukan', style: TextStyle(color: Colors.white70, fontSize: 11)), Text('Rp ${_totalPemasukan.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))]),
                      ]),
                      Row(children: [
                        const CircleAvatar(radius: 14, backgroundColor: Colors.white24, child: Icon(Icons.arrow_upward, color: Colors.white, size: 16)),
                        const SizedBox(width: 8),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Pengeluaran', style: TextStyle(color: Colors.white70, fontSize: 11)), Text('Rp ${_totalPengeluaran.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))]),
                      ]),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 25),

            const Text('Transaksi Terbaru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            
            _daftarTransaksi.isEmpty
                ? const Center(child: Text('Belum ada transaksi.'))
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
                        child: ListTile(
                          // OPSI 3: Mengarahkan ke Halaman Detail saat list di-klik
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HalamanDetailTransaksi(transaksi: item))),
                          leading: CircleAvatar(
                            backgroundColor: isPemasukan ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                            child: Icon(isPemasukan ? Icons.account_balance_wallet_rounded : Icons.shopping_bag_rounded, color: isPemasukan ? Colors.green : Colors.red),
                          ),
                          title: Text(item.judul, style: const TextStyle(widgets: [FontWeight.bold], fontSize: 14)),
                          subtitle: Text(item.kategori, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          trailing: Text('${isPemasukan ? "+" : "-"} Rp ${item.jumlah.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.bold, color: isPemasukan ? Colors.green : Colors.red)),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  void _tampilkanFormInput(BuildContext context) {
    final judulController = TextEditingController();
    final jumlahController = TextEditingController();
    final catatanController = TextEditingController();
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
                children: [
                  const Text('Tambah Catatan Keuangan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF008A45))),
                  const SizedBox(height: 15),
                  TextField(controller: judulController, decoration: const InputDecoration(labelText: 'Keterangan', border: OutlineInputBorder())),
                  const SizedBox(height: 12),
                  TextField(controller: jumlahController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Nominal (Rp)', border: OutlineInputBorder())),
                  const SizedBox(height: 12),
                  TextField(controller: catatanController, decoration: const InputDecoration(labelText: 'Catatan Tambahan (Opsional)', border: OutlineInputBorder())),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ChoiceChip(label: const Text('Pemasukan'), selected: jenisTerpilih == 'pemasukan', onSelected: (val) => setModalState(() { jenisTerpilih = 'pemasukan'; kategoriTerpilih = 'Saku'; })),
                      ChoiceChip(label: const Text('Pengeluaran'), selected: jenisTerpilih == 'pengeluaran', onSelected: (val) => setModalState(() { jenisTerpilih = 'pengeluaran'; kategoriTerpilih = 'Konsumsi'; })),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF008A45)),
                      onPressed: () {
                        if (judulController.text.isEmpty || jumlahController.text.isEmpty) return;
                        final nominal = double.tryParse(jumlahController.text) ?? 0;
                        _tambahTransaksiBaru(judulController.text, nominal, jenisTerpilih, kategoriTerpilih, catatanController.text);
                        Navigator.pop(context);
                      },
                      child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

// ==========================================
// OPSI 3: HALAMAN DETAIL TRANSAKSI
// ==========================================
class HalamanDetailTransaksi extends StatelessWidget {
  final Transaksi transaksi;
  const HalamanDetailTransaksi({super.key, required this.transaksi});

  @override
  Widget build(BuildContext context) {
    final isPemasukan = transaksi.jenis == 'pemasukan';
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Transaksi'), backgroundColor: const Color(0xFF008A45), foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(transaksi.kategori, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                    Icon(isPemasukan ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded, color: isPemasukan ? Colors.green : Colors.red),
                  ],
                ),
                const Divider(height: 20),
                const SizedBox(height: 10),
                Text(transaksi.judul, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(
                  '${isPemasukan ? "+" : "-"} Rp ${transaksi.jumlah.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: isPemasukan ? Colors.green : Colors.red),
                ),
                const SizedBox(height: 20),
                const Text('Catatan Pengguna:', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 4),
                Text(transaksi.catatan, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 20),
                Text('Tanggal: ${transaksi.tanggal.day}/${transaksi.tanggal.month}/${transaksi.tanggal.year}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
