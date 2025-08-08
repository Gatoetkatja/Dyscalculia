import 'package:discalculia/main_page.dart';
import 'package:discalculia/page/explained_subtes.dart';
import 'package:discalculia/page/konsultasi.dart';
import 'package:discalculia/question_page.dart';
import 'package:discalculia/srt_question_screen.dart';
import 'package:discalculia/widgets/dot_enum.dart';
import 'package:discalculia/widgets/perbandingan.dart';
import 'package:discalculia/widgets/tes_widget.dart';
import 'package:flutter/material.dart';
import 'package:discalculia/questions_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(body: DemoSubtestScreen(),),) // ganti dari QuizQuestionPage()
  );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // App Branding
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Dytec',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Aplikasi ini membantu mendeteksi potensi diskalkulia dengan serangkaian subtes yang interaktif dan mudah dipahami.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                  Image.network(
                    'https://cdn-icons-png.flaticon.com/512/3062/3062634.png',
                    height: 180,
                  ),
                ],
              ),

              // Button CTA
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => QuizQuestionPage()),
                      );
                    },
                    icon: Icon(Icons.play_arrow),
                    label: Text(
                      'Mulai Tes Sekarang',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF27AE60),
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                      shadowColor: Colors.green.withOpacity(0.3),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Waktu pengerjaan sekitar 5-10 menit',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
