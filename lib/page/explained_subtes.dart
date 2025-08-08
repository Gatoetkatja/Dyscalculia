import 'package:flutter/material.dart';

// Enum untuk kategori skor berdasarkan grafik distribusi normal
enum ScoreCategory {
  excellent,    // 8-9 (7% + 4% = 11%)
  aboveAverage, // 6-7 (17% + 12% = 29%)  
  average,      // 4-6 (17% + 20% = 37%)
  belowAverage, // 2-4 (7% + 12% = 19%)
  needsAttention // 1-2 (4% total)
}

// Helper class untuk interpretasi skor
class ScoreInterpretation {
  static ScoreCategory getCategory(double score) {
    if (score >= 8.0) return ScoreCategory.excellent;
    if (score >= 6.0) return ScoreCategory.aboveAverage;
    if (score >= 4.0) return ScoreCategory.average;
    if (score >= 2.0) return ScoreCategory.belowAverage;
    return ScoreCategory.needsAttention;
  }

  static String getCategoryName(ScoreCategory category) {
    switch (category) {
      case ScoreCategory.excellent:
        return 'Sangat Baik';
      case ScoreCategory.aboveAverage:
        return 'Di Atas Rata-rata';
      case ScoreCategory.average:
        return 'Rata-rata';
      case ScoreCategory.belowAverage:
        return 'Di Bawah Rata-rata';
      case ScoreCategory.needsAttention:
        return 'Perlu Perhatian Khusus';
    }
  }

  static Color getCategoryColor(ScoreCategory category) {
    switch (category) {
      case ScoreCategory.excellent:
        return Colors.green.shade600;
      case ScoreCategory.aboveAverage:
        return Colors.lightGreen.shade600;
      case ScoreCategory.average:
        return Colors.blue.shade600;
      case ScoreCategory.belowAverage:
        return Colors.orange.shade600;
      case ScoreCategory.needsAttention:
        return Colors.red.shade600;
    }
  }

  static IconData getCategoryIcon(ScoreCategory category) {
    switch (category) {
      case ScoreCategory.excellent:
        return Icons.emoji_events;
      case ScoreCategory.aboveAverage:
        return Icons.trending_up;
      case ScoreCategory.average:
        return Icons.remove;
      case ScoreCategory.belowAverage:
        return Icons.trending_down;
      case ScoreCategory.needsAttention:
        return Icons.priority_high;
    }
  }
}

// Widget universal untuk semua subtes
class SubtestRangeExplanation extends StatelessWidget {
  final String subtestName;
  final String subtestDescription;
  final IconData icon;
  final Color primaryColor;
  final String specialInfo;

  const SubtestRangeExplanation({
    Key? key,
    required this.subtestName,
    required this.subtestDescription,
    required this.icon,
    required this.primaryColor,
    this.specialInfo = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  subtestName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Description Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tentang Subtes Ini',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  subtestDescription,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (specialInfo.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    specialInfo,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: primaryColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Score Range Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.bar_chart,
                      size: 18,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Interpretasi Range Skor (1-9)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildScoreRange('8 - 9', 'Sangat Baik', Colors.green.shade600, '11%'),
                _buildScoreRange('6 - 7', 'Di Atas Rata-rata', Colors.lightGreen.shade600, '29%'),
                _buildScoreRange('4 - 5', 'Rata-rata', Colors.blue.shade600, '37%'),
                _buildScoreRange('2 - 3', 'Di Bawah Rata-rata', Colors.orange.shade600, '19%'),
                _buildScoreRange('1', 'Perlu Perhatian Khusus', Colors.red.shade600, '4%'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRange(String range, String label, Color color, String percentage) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 50,
            child: Text(
              range,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              percentage,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Screen dengan semua subtes
class SubtestRangeScreen extends StatelessWidget {
  const SubtestRangeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade600,
        title: const Text(
          'Range Skor Subtes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            SubtestRangeExplanation(
              subtestName: 'Subtes DOT',
              subtestDescription: 'Mengukur kemampuan visual untuk mengenali jumlah dengan cepat tanpa menghitung satu per satu. Seperti melihat dadu dan langsung tahu angkanya!',
              icon: Icons.fiber_manual_record,
              primaryColor: Colors.blue.shade600,
              specialInfo: 'Kemampuan subitizing - mengenali pola visual angka dengan cepat.',
            ),
            
            SubtestRangeExplanation(
              subtestName: 'Subtes STROOP',
              subtestDescription: 'Mengukur kemampuan fokus dan kontrol inhibisi. Menilai seberapa baik seseorang dapat mengabaikan informasi yang mengganggu dan fokus pada tugas utama.',
              icon: Icons.palette,
              primaryColor: Colors.orange.shade600,
              specialInfo: 'Test kontrol kognitif dan fleksibilitas mental.',
            ),
            
            SubtestRangeExplanation(
              subtestName: 'Subtes ADD (Penjumlahan)',
              subtestDescription: 'Mengukur kemampuan operasi penjumlahan dasar. Menilai kecepatan dan akurasi dalam melakukan perhitungan penjumlahan sederhana.',
              icon: Icons.add_circle,
              primaryColor: Colors.purple.shade600,
              specialInfo: 'Fundamental untuk kemampuan matematika dasar.',
            ),
            
            SubtestRangeExplanation(
              subtestName: 'Subtes MULT (Perkalian)',
              subtestDescription: 'Mengukur kemampuan operasi perkalian. Menilai pemahaman konsep perkalian dan kemampuan mengingat tabel perkalian dasar.',
              icon: Icons.close,
              primaryColor: Colors.pink.shade600,
              specialInfo: 'Membutuhkan pemahaman konsep dan memori jangka panjang.',
            ),
            
            SubtestRangeExplanation(
              subtestName: 'Subtes SUB (Pengurangan)',
              subtestDescription: 'Mengukur kemampuan operasi pengurangan. Menilai kecepatan dan akurasi dalam melakukan perhitungan pengurangan dengan berbagai tingkat kesulitan.',
              icon: Icons.remove_circle,
              primaryColor: Colors.cyan.shade600,
              specialInfo: 'Kemampuan berpikir mundur dan logika numerik.',
            ),
            
            SubtestRangeExplanation(
              subtestName: 'Subtes Simple Reaction Time',
              subtestDescription: 'Mengukur kecepatan respons terhadap stimulus sederhana. Menilai waktu yang dibutuhkan untuk memberikan reaksi terhadap sinyal visual atau auditori.',
              icon: Icons.timer,
              primaryColor: Colors.green.shade600,
              specialInfo: 'Indikator kecepatan pemrosesan kognitif dasar.',
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Demo screen untuk testing
class DemoSubtestRangeScreen extends StatelessWidget {
  const DemoSubtestRangeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SubtestRangeScreen();
  }
}