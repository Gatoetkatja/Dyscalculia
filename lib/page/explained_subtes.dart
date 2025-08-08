import 'package:flutter/material.dart';

// Enum untuk kategori skor
enum ScoreCategory {
  excellent,    // 6.0 - 7.0
  aboveAverage, // 4.5 - 5.9  
  average,      // 3.0 - 4.4
  belowAverage, // 1.5 - 2.9
  needsAttention // 0.0 - 1.4
}

// Helper class untuk interpretasi skor
class ScoreInterpretation {
  static ScoreCategory getCategory(double score) {
    if (score >= 6.0) return ScoreCategory.excellent;
    if (score >= 4.5) return ScoreCategory.aboveAverage;
    if (score >= 3.0) return ScoreCategory.average;
    if (score >= 1.5) return ScoreCategory.belowAverage;
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

  static MaterialColor getCategoryColor(ScoreCategory category) {
    switch (category) {
      case ScoreCategory.excellent:
        return Colors.green;
      case ScoreCategory.aboveAverage:
        return Colors.lightGreen;
      case ScoreCategory.average:
        return Colors.blue;
      case ScoreCategory.belowAverage:
        return Colors.orange;
      case ScoreCategory.needsAttention:
        return Colors.red;
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

// Widget untuk Subtes DOT dengan penjelasan range
class DotSubtestExplanation extends StatelessWidget {
  final double score;

  const DotSubtestExplanation({Key? key, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final category = ScoreInterpretation.getCategory(score);
    final categoryName = ScoreInterpretation.getCategoryName(category);
    final categoryColor = ScoreInterpretation.getCategoryColor(category);
    final categoryIcon = ScoreInterpretation.getCategoryIcon(category);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.fiber_manual_record,
                  color: Colors.blue.shade600,
                  size: 28,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subtes DOT',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    Text(
                      'Skor: $score',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600] ?? Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: categoryColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  categoryIcon,
                  color: categoryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  categoryName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: categoryColor[700] ?? categoryColor,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🎯 Apa itu Subtes DOT?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800] ?? Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Subtes ini mengukur kemampuan visual untuk mengenali jumlah dengan cepat tanpa menghitung satu per satu. Seperti melihat dadu dan langsung tahu angkanya!',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Range Explanation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50] ?? Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200] ?? Colors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📊 Rentang Skor DOT',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800] ?? Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                _buildScoreRange('6.0 - 7.0', 'Sangat Baik', Colors.green, score >= 6.0),
                _buildScoreRange('4.5 - 5.9', 'Di Atas Rata-rata', Colors.lightGreen, score >= 4.5 && score < 6.0),
                _buildScoreRange('3.0 - 4.4', 'Rata-rata', Colors.blue, score >= 3.0 && score < 4.5),
                _buildScoreRange('1.5 - 2.9', 'Di Bawah Rata-rata', Colors.orange, score >= 1.5 && score < 3.0),
                _buildScoreRange('0.0 - 1.4', 'Perlu Perhatian Khusus', Colors.red, score < 1.5),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Interpretation based on score
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: categoryColor.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getInterpretationTitle(category),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: categoryColor[800] ?? categoryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getDotInterpretation(category),
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: categoryColor[700] ?? categoryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRange(String range, String label, Color color, bool isCurrentRange) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isCurrentRange ? color.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isCurrentRange ? Border.all(color: color.withOpacity(0.5)) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            child: Text(
              range,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isCurrentRange ? FontWeight.bold : FontWeight.normal,
                color: isCurrentRange ? (Colors.red ?? color) : Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isCurrentRange ? FontWeight.bold : FontWeight.normal,
                color: isCurrentRange ? (Colors.red ?? color) : Colors.grey[600],
              ),
            ),
          ),
          if (isCurrentRange)
            Icon(
              Icons.arrow_back,
              size: 16,
              color: Colors.red ?? color,
            ),
        ],
      ),
    );
  }

  String _getInterpretationTitle(ScoreCategory category) {
    switch (category) {
      case ScoreCategory.excellent:
        return '🌟 Kemampuan Visual Excellent!';
      case ScoreCategory.aboveAverage:
        return '👍 Kemampuan Visual Baik!';
      case ScoreCategory.average:
        return '😊 Kemampuan Visual Normal';
      case ScoreCategory.belowAverage:
        return '💪 Mari Latihan Visual!';
      case ScoreCategory.needsAttention:
        return '🎯 Butuh Latihan Intensif';
    }
  }

  String _getDotInterpretation(ScoreCategory category) {
    switch (category) {
      case ScoreCategory.excellent:
        return 'Kemampuan visual counting kamu luar biasa! Kamu bisa mengenali pola angka dengan sangat cepat dan akurat. Pertahankan kemampuan ini!';
      case ScoreCategory.aboveAverage:
        return 'Kemampuan visual kamu di atas rata-rata. Kamu cukup baik dalam mengenali jumlah tanpa menghitung detail. Terus tingkatkan!';
      case ScoreCategory.average:
        return 'Kemampuan visual kamu normal seperti kebanyakan orang. Ini foundation yang baik untuk belajar matematika lebih lanjut.';
      case ScoreCategory.belowAverage:
        return 'Kemampuan visual masih bisa ditingkatkan. Dengan latihan rutin mengenali pola angka, kemampuan ini akan berkembang pesat.';
      case ScoreCategory.needsAttention:
        return 'Kemampuan visual perlu latihan intensif. Disarankan berlatih dengan games visual counting dan konsultasi dengan ahli.';
    }
  }
}

// Widget serupa untuk subtes lainnya...
class GeneralSubtestExplanation extends StatelessWidget {
  final String subtestName;
  final String subtestDescription;
  final double score;
  final IconData icon;
  final MaterialColor primaryColor;

  const GeneralSubtestExplanation({
    Key? key,
    required this.subtestName,
    required this.subtestDescription,
    required this.score,
    required this.icon,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final category = ScoreInterpretation.getCategory(score);
    final categoryName = ScoreInterpretation.getCategoryName(category);
    final categoryColor = ScoreInterpretation.getCategoryColor(category);
    final categoryIcon = ScoreInterpretation.getCategoryIcon(category);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor[100] ?? primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: primaryColor[600] ?? primaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subtestName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryColor[700] ?? primaryColor,
                      ),
                    ),
                    Text(
                      'Skor: $score',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: categoryColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  categoryIcon,
                  color: categoryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  categoryName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: categoryColor[700] ?? categoryColor,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor[50] ?? primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📋 Tentang $subtestName',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor[800] ?? primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtestDescription,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Universal Range Explanation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📊 Interpretasi Skor',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800] ?? Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                _buildScoreRange('6.0 - 7.0', 'Sangat Baik', Colors.green, score >= 6.0),
                _buildScoreRange('4.5 - 5.9', 'Di Atas Rata-rata', Colors.lightGreen, score >= 4.5 && score < 6.0),
                _buildScoreRange('3.0 - 4.4', 'Rata-rata', Colors.blue, score >= 3.0 && score < 4.5),
                _buildScoreRange('1.5 - 2.9', 'Di Bawah Rata-rata', Colors.orange, score >= 1.5 && score < 3.0),
                _buildScoreRange('0.0 - 1.4', 'Perlu Perhatian Khusus', Colors.red, score < 1.5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRange(String range, String label, Color color, bool isCurrentRange) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isCurrentRange ? color.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isCurrentRange ? Border.all(color: color.withOpacity(0.5)) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            child: Text(
              range,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isCurrentRange ? FontWeight.bold : FontWeight.normal,
                color: isCurrentRange ? Colors.red : Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isCurrentRange ? FontWeight.bold : FontWeight.normal,
                color: isCurrentRange ? Colors.red : Colors.grey.shade600,
              ),
            ),
          ),
          if (isCurrentRange)
            Icon(
              Icons.arrow_back,
              size: 16,
              color: Colors.red ?? color,
            ),
        ],
      ),
    );
  }
}

// Screen dengan semua subtes
class SubtestExplanationScreen extends StatelessWidget {
  final Map<String, double> scores;

  const SubtestExplanationScreen({
    Key? key,
    required this.scores,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100] ?? Colors.grey.withOpacity(0.1),
      appBar: AppBar(
        backgroundColor: Colors.indigo[600] ?? Colors.indigo,
        title: const Text(
          'Penjelasan Range Skor Tes',
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
            DotSubtestExplanation(score: scores['dot'] ?? 0.0),
            GeneralSubtestExplanation(
              subtestName: 'Subtes STROOP',
              subtestDescription: 'Mengukur kemampuan fokus dan kontrol inhibisi. Menilai seberapa baik seseorang dapat mengabaikan informasi yang mengganggu dan fokus pada tugas utama.',
              score: scores['stroop'] ?? 0.0,
              icon: Icons.palette,
              primaryColor: Colors.orange,
            ),
            GeneralSubtestExplanation(
              subtestName: 'Subtes ADD (Penjumlahan)',
              subtestDescription: 'Mengukur kemampuan operasi penjumlahan dasar. Menilai kecepatan dan akurasi dalam melakukan perhitungan penjumlahan sederhana.',
              score: scores['add'] ?? 0.0,
              icon: Icons.add_circle,
              primaryColor: Colors.purple,
            ),
            GeneralSubtestExplanation(
              subtestName: 'Subtes MULT (Perkalian)',
              subtestDescription: 'Mengukur kemampuan operasi perkalian. Menilai pemahaman konsep perkalian dan kemampuan mengingat tabel perkalian dasar.',
              score: scores['mult'] ?? 0.0,
              icon: Icons.close,
              primaryColor: Colors.pink,
            ),
            GeneralSubtestExplanation(
              subtestName: 'Subtes SUB (Pengurangan)',
              subtestDescription: 'Mengukur kemampuan operasi pengurangan. Menilai kecepatan dan akurasi dalam melakukan perhitungan pengurangan dengan berbagai tingkat kesulitan.',
              score: scores['sub'] ?? 0.0,
              icon: Icons.remove_circle,
              primaryColor: Colors.cyan,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Demo dengan skor dari gambar
class DemoSubtestScreen extends StatelessWidget {
  const DemoSubtestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, double> testScores = {
      'dot': 3.4,      // Rata-rata
      'stroop': 3.3,   // Rata-rata  
      'add': 5.2,      // Di atas rata-rata
      'mult': 1.6,     // Di bawah rata-rata
      'sub': 1.9,      // Di bawah rata-rata
    };

    return SubtestExplanationScreen(scores: testScores);
  }
}