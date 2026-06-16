import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const DompetSakuApp());
}

// ==========================================
// DATA MODEL + JSON SERIALIZATION
// ==========================================
class Transaksi {
  final String id;
  final String judul;
  final double jumlah;
  final String jenis; 
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'jumlah': jumlah,
      'jenis': jenis,
      'kategori': kategori,
      'tanggal': tanggal.toIso8601String(),
      'catatan': catatan,
    };
  }

  factory Transaksi.fromMap(Map<String, dynamic> map) {
    return Transaksi(
      id: map['id'],
      judul: map['judul'],
      jumlah: map['jumlah'],
      jenis: map['jenis'],
      kategori: map['kategori'],
      tanggal: DateTime.parse(map['tanggal']),
      catatan: map['catatan'],
    );
  }
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
  List<Transaksi> _daftarTransaksi = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _muatDataTransaksi();
  }

  Future<void> _muatDataTransaksi() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataString = prefs.getString('saved_transaksi');
    
    if (dataString != null) {
      final List<dynamic> dataDidecode = json.decode(dataString);
      setState(() {
        _daftarTransaksi = dataDidecode.map((item) => Transaksi.fromMap(item)).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _daftarTransaksi = [
          Transaksi(id: 't1', judul: 'Uang Saku Bulanan', jumlah: 500000, jenis: 'pemasukan', kategori: 'Saku', tanggal: DateTime.now(), catatan: 'Transferan awal bulan.'),
        ];
        _isLoading = false;
      });
    }
  }

  Future<void> _simpanKeDatabase() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> dataMap = _daftarTransaksi.map((t) => t.toMap()).toList();
    await prefs.setString('saved_transaksi', json.encode(dataMap));
  }

  double get _totalPemasukan => _daftarTransaksi.where((t) => t.jenis == 'pemasukan').fold(0, (sum, item) => sum + item.jumlah);
  double get _totalPengeluaran => _daftarTransaksi.where((t) => t.jenis == 'pengeluaran').fold(0, (sum, item) => sum + item.jumlah);
  double get _totalSaldo => _totalPemasukan - _totalPengeluaran;

  // FITUR: TAMBAH DATA
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
    _simpanKeDatabase();
  }

  // FITUR: EDIT DATA
  void _editTransaksi(String id, String judul, double jumlah, String jenis, String kategori, String catatan) {
    final index = _daftarTransaksi.indexWhere((t) => t.id == id);
    if (index >= 0) {
      setState(() {
        _daftarTransaksi[index] = Transaksi(
          id: id,
          judul: judul,
          jumlah: jumlah,
          jenis: jenis,
          kategori: kategori,
          tanggal: _daftarTransaksi[index].tanggal, // tanggal tetap sama
          catatan: catatan.isEmpty ? 'Tidak ada catatan tambahan.' : catatan,
        );
      });
      _simpanKeDatabase();
    }
  }

  // FITUR: HAPUS DATA
  void _hapusTransaksi(String id) {
    setState(() {
      _daftarTransaksi.removeWhere((t) => t.id == id);
    });
    _simpanKeDatabase();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _isLoading ? const Center(child: CircularProgressIndicator()) : _buildDashboardBeranda(),
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
        child: const Icon(Icons.add_circle, color: Colors.white, size: 32),
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
                ? const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('Belum ada transaksi.', style: TextStyle(color: Colors.grey))))
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HalamanDetailTransaksi(
                                  transaksi: item,
                                  onDelete: (id) => _hapusTransaksi(id),
                                  onEdit: _tampilkanFormEdit,
                                ),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            backgroundColor: isPemasukan ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                            child: Icon(isPemasukan ? Icons.account_balance_wallet_rounded : Icons.shopping_bag_rounded, color: isPemasukan ? Colors.green : Colors.red),
                          ),
                          title: Text(item.judul, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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

  void _tampilkanFormEdit(BuildContext context, Transaksi transaksi) {
    final judulController = TextEditingController(text: transaksi.judul);
    final jumlahController = TextEditingController(text: transaksi.jumlah.toStringAsFixed(0));
    final catatanController = TextEditingController(text: transaksi.catatan == 'Tidak ada catatan tambahan.' ? '' : transaksi.catatan);
    String jenisTerpilih = transaksi.jenis;
    String kategoriTerpilih = transaksi.kategori;

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
                  const Text('Ubah Catatan Keuangan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
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
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      onPressed: () {
                        if (judulController.text.isEmpty || jumlahController.text.isEmpty) return;
                        final nominal = double.tryParse(jumlahController.text) ?? 0;
                        _editTransaksi(transaksi.id, judulController.text, nominal, jenisTerpilih, kategoriTerpilih, catatanController.text);
                        
                        // Menutup modal bottom sheet
                        Navigator.pop(context);
                        // Menutup halaman detail untuk me-refresh data di beranda
                        Navigator.pop(context);
                      },
                      child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

class HalamanDetailTransaksi extends StatelessWidget {
  final Transaksi transaksi;
  final Function(String) onDelete;
  final Function(BuildContext, Transaksi) onEdit;

  const HalamanDetailTransaksi({
    super.key, 
    required this.transaksi, 
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isPemasukan = transaksi.jenis == 'pemasukan';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi'), 
        backgroundColor: const Color(0xFF008A45), 
        foregroundColor: Colors.white,
        actions: [
          // TOMBOL EDIT
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => onEdit(context, transaksi),
          ),
          // TOMBOL HAPUS
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.white),
            onPressed: () {
              // Dialog Konfirmasi Hapus
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Hapus Transaksi?'),
                  content: const Text('Apakah kamu yakin ingin menghapus catatan keuangan ini?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                    TextButton(
                      onPressed: () {
                        onDelete(transaksi.id);
                        Navigator.pop(context); // Tutup dialog
                        Navigator.pop(context); // Kembali ke beranda
                      }, 
                      child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
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
