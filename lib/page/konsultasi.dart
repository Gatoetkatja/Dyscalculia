import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DiskalkuliaConsultationScreen extends StatelessWidget {
  const DiskalkuliaConsultationScreen({Key? key}) : super(key: key);

  // Fungsi untuk membuka WhatsApp dengan template pesan
  Future<void> _launchWhatsApp(BuildContext context) async {
    const String phoneNumber = '6281234567890'; // Ganti dengan nomor psikolog
    const String message = '''
Halo Dr. Sarah Wijaya,

Saya tertarik untuk berkonsultasi mengenai diskalkulia.

Nama: [Nama Anda]
Usia: [Usia]
Keluhan: [Jelaskan keluhan Anda]

Mohon informasi jadwal yang tersedia untuk konsultasi. Terima kasih.
''';

    try {
      final Uri whatsappUri = Uri.parse(
          'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');
      
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackbar(context, 'WhatsApp tidak terinstall atau tidak dapat dibuka');
      }
    } catch (e) {
      _showErrorSnackbar(context, 'Terjadi kesalahan saat membuka WhatsApp');
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(2, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child:Text(
                          'Konsultasi Diskalkulia',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                  ],
                ),
              ),

            // Profile Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  
                  // Foto Profile
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.teal.shade200,
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.teal.shade100,
                      // Ganti dengan NetworkImage atau AssetImage untuk foto asli
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.teal.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Nama Psikolog
                  const Text(
                    'Dr. Sarah Wijaya, M.Psi.',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  // Spesialis
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.teal.shade200),
                    ),
                    child: Text(
                      'Spesialis Kesulitan Belajar & Diskalkulia',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.teal.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: List.generate(5, (index) => 
                          Icon(Icons.star, color: Colors.amber, size: 20)
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '4.9 (127 ulasan)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Informasi Singkat
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade600, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Tentang Psikolog',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Psikolog berpengalaman lebih dari 8 tahun dalam menangani kesulitan belajar, khususnya diskalkulia. Lulusan S2 Psikologi Klinis dari Universitas Indonesia. Telah membantu ratusan anak dan dewasa mengatasi kesulitan matematika dengan pendekatan terapi yang personal dan efektif.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSkillChip('Terapi Diskalkulia'),
                      _buildSkillChip('Asesmen Psikologi'),
                      _buildSkillChip('Konseling Keluarga'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Jadwal Konsultasi
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.green.shade600, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Jadwal Konsultasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildScheduleItem('Senin - Jumat', '09.00 - 17.00 WIB'),
                  _buildScheduleItem('Sabtu', '09.00 - 15.00 WIB'),
                  _buildScheduleItem('Minggu', 'Tutup'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.green.shade600, size: 16),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Konsultasi dapat dilakukan secara online atau offline',
                            style: TextStyle(fontSize: 12, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Harga
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.attach_money, color: Colors.orange.shade600, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Tarif Konsultasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildPriceItem('Konsultasi Awal (90 menit)', 'Rp 400.000'),
                  _buildPriceItem('Konsultasi Lanjutan (60 menit)', 'Rp 300.000'),
                  _buildPriceItem('Asesmen Diskalkulia', 'Rp 800.000'),
                  _buildPriceItem('Paket 4x Sesi Terapi', 'Rp 1.000.000'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Tombol WhatsApp
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => _launchWhatsApp(context),
                icon: const Icon(
                  Icons.chat,
                  color: Colors.white,
                  size: 24,
                ),
                label: const Text(
                  'Hubungi via WhatsApp',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // WhatsApp green
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Info footer
            Text(
              'Dengan menekan tombol di atas, Anda akan diarahkan ke WhatsApp dengan template pesan konsultasi.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Text(
        skill,
        style: TextStyle(
          fontSize: 12,
          color: Colors.blue.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildScheduleItem(String day, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 15,
              color: time == 'Tutup' ? Colors.red.shade600 : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceItem(String service, String price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              service,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              price,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}