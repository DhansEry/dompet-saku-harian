import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatelessWidget {
  final VoidCallback onDataRestored; // Callback untuk menyegarkan data di halaman utama

  const ProfilePage({Key? key, required this.onDataRestored}) : super(key: key);

  // FUNGSI 1: Ekspor data ke file dan Bagikan (Backup)
  Future<void> _handleBackup(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? txData = prefs.getString('saved_transactions');

      if (txData == null || txData == '[]') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Belum ada data transaksi untuk dicadangkan!')),
        );
        return;
      }

      // Buat file temporer di dalam sistem
      final tempDir = await getTemporaryDirectory();
      final file = Scaffold(body: Container()); // Placeholder
      final String fileName = 'Backup_DompetSaku_${DateTime.now().millisecondsSinceEpoch}.json';
      final File backupFile = File('${tempDir.path}/$fileName');

      // Tulis data transaksi ke file tersebut
      await backupFile.writeAsString(txData);

      // Munculkan menu Share bawaan Android (bisa pilih Google Drive, WA, dll)
      final XFile xFile = XFile(backupFile.path);
      await Share.shareXFiles([xFile], text: 'File Cadangan Dompet Saku Harian');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuat cadangan: $e')),
      );
    }
  }

  // FUNGSI 2: Ambil file JSON dan masukkan kembali ke aplikasi (Restore)
  Future<void> _handleRestore(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final File file = File(result.files.single.path!);
        final String content = await file.readAsString();

        // Validasi struktur file JSON apakah benar data transaksi
        final decoded = jsonDecode(content);
        if (decoded is List) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('saved_transactions', content);

          // Panggil fungsi refresh data utama
          onDataRestored();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('🎉 Data berhasil dipulihkan kembali!')),
          );
        } else {
          throw const FormatException('Format file cadangan tidak valid');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memulihkan data: $e')),
      );
    }
  }

  void _showFeatureAlert(BuildContext context, String featureName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.info_outline, color: Color(0xFF0D9488)),
              const SizedBox(width: 10),
              Text(featureName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          content: Text(
            'Fitur untuk $featureName sedang dalam tahap pengembangan!',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Mengerti', style: TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Profil Pengguna', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF0D9488),
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pengguna Dompet Saku',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Surabaya, Indonesia',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 32),

            _buildProfileTile(
              context,
              icon: Icons.security_rounded,
              title: 'Keamanan & PIN',
              subtitle: 'Amankan akses aplikasi Anda',
              onTap: () => _showFeatureAlert(context, 'Keamanan & PIN'),
            ),
            _buildProfileTile(
              context,
              icon: Icons.palette_outlined,
              title: 'Tema Aplikasi',
              subtitle: 'Sesuaikan warna visual sistem',
              onTap: () => _showFeatureAlert(context, 'Tema Aplikasi'),
            ),
            // SEKARANG AKTIF: Tombol Cadangkan Data
            _buildProfileTile(
              context,
              icon: Icons.cloud_upload_outlined,
              title: 'Cadangkan Data',
              subtitle: 'Ekspor data transaksi ke Google Drive/File',
              onTap: () => _handleBackup(context),
            ),
            // SEKARANG AKTIF: Tombol Pulihkan Data
            _buildProfileTile(
              context,
              icon: Icons.cloud_download_outlined,
              title: 'Pulihkan Data',
              subtitle: 'Impor kembali data dari file cadangan',
              onTap: () => _handleRestore(context),
            ),
            _buildProfileTile(
              context,
              icon: Icons.help_outline_rounded,
              title: 'Pusat Bantuan',
              subtitle: 'Pertanyaan umum seputar fitur',
              onTap: () => _showFeatureAlert(context, 'Pusat Bantuan'),
            ),

            const SizedBox(height: 40),
            const Text('Versi Aplikasi 1.2.0', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF0D9488).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF0D9488)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
      ),
    );
  }
}
