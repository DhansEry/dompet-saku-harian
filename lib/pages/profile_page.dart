import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
            'Fitur untuk $featureName sedang dalam tahap pengembangan dan akan segera aktif pada pembaruan berikutnya!',
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
            // Avatar dan Nama Pengguna
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

            // Daftar Tombol Fitur Pengaturan
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
            _buildProfileTile(
              context,
              icon: Icons.cloud_upload_outlined,
              title: 'Cadangan Data',
              subtitle: 'Simpan data transaksi ke cloud',
              onTap: () => _showFeatureAlert(context, 'Cadangan Data'),
            ),
            _buildProfileTile(
              context,
              icon: Icons.help_outline_rounded,
              title: 'Pusat Bantuan',
              subtitle: 'Pertanyaan umum seputar fitur',
              onTap: () => _showFeatureAlert(context, 'Pusat Bantuan'),
            ),

            const SizedBox(height: 40),
            const Text(
              'Versi Aplikasi 1.1.0',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
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
