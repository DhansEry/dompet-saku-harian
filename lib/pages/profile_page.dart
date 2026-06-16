import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Bagian Header Profil
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF0D9488),
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Text(
              'Pengguna Dompet Saku',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Surabaya, Indonesia',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 30),

            // Opsi Menu Pengaturan
            _buildProfileItem(Icons.security, 'Keamanan & PIN', 'Amankan akses aplikasi Anda'),
            _buildProfileItem(Icons.color_lens_outlined, 'Tema Aplikasi', 'Sesuaikan warna visual sistem'),
            _buildProfileItem(Icons.backup_outlined, 'Cadangkan Data', 'Simpan data transaksi ke cloud'),
            _buildProfileItem(Icons.help_outline_rounded, 'Pusat Bantuan', 'Pertanyaan umum seputar fitur'),
            
            const SizedBox(height: 20),
            const Text('Versi Aplikasi 1.1.0', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0D9488)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}
