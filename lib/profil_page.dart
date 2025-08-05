// lib/profile_screen.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: SingleChildScrollView( // Agar halaman bisa digulir kalau kontennya panjang
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Pusatkan elemen di kolom
              children: [
                // --- Bagian Foto Profil ---
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 60, // Ukuran lingkaran avatar
                  backgroundColor: Colors.grey, // Warna latar belakang jika tidak ada gambar
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Ganti dengan URL foto profil asli
                  // atau AssetImage('assets/images/user_avatar.png'), jika dari lokal
                ),
                const SizedBox(height: 15),
                const Text(
                  'Nama Pengguna', // Ganti dengan nama pengguna asli
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'email.pengguna@example.com', // Ganti dengan email pengguna asli
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 125, 124, 124),
                  ),
                ),
                const SizedBox(height: 30), // Spasi sebelum daftar opsi
          
                // --- Bagian Opsi Profil (ListTile) ---
                Card( // Menggunakan Card untuk memberikan tampilan "kartu" yang rapi
                  elevation: 4, // Bayangan kartu
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: const Color.fromARGB(255, 250, 248, 248),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person, color: Colors.teal),
                        title: const Text('Edit Profil'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // Aksi ketika 'Edit Profil' ditekan
                          print('Edit Profil ditekan!');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Menuju halaman Edit Profil')),
                          );
                        },
                      ),
                      const Divider(indent: 15, endIndent: 15), // Garis pemisah
                      ListTile(
                        leading: const Icon(Icons.settings, color: Colors.teal),
                        title: const Text('Pengaturan'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // Aksi ketika 'Pengaturan' ditekan
                          print('Pengaturan ditekan!');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Menuju halaman Pengaturan')),
                          );
                        },
                      ),
                      const Divider(indent: 15, endIndent: 15),
                      ListTile(
                        leading: const Icon(Icons.info, color: Colors.teal),
                        title: const Text('Tentang Aplikasi'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // Aksi ketika 'Tentang Aplikasi' ditekan
                          print('Tentang Aplikasi ditekan!');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Menuju halaman Tentang Aplikasi')),
                          );
                        },
                      ),
                      const Divider(indent: 15, endIndent: 15),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red), // Ikon logout biasanya merah
                        title: const Text('Keluar', style: TextStyle(color: Colors.red)),
                        onTap: () {
                          // Aksi ketika 'Keluar' ditekan
                          print('Keluar ditekan!');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Anda telah keluar')),
                          );
                          // Biasanya, di sini akan ada logika untuk logout dan kembali ke halaman login
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20), // Spasi di bagian bawah
              ],
            ),
          ),
        ),
      );
  }
}