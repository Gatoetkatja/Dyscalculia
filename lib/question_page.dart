import 'package:discalculia/discalculia.dart';
import 'package:discalculia/result_page.dart';
import 'package:discalculia/widgets/answer_button.dart';
import 'package:flutter/material.dart';
import 'package:discalculia/data/questions_data.dart';


class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {

  String? _selectedAnswer; // Menyimpan ID alasan yang dipilih
  int questionIndex = 0;
  double progress = 0;

  @override
  Widget build(BuildContext context) {

    if(questionIndex == QuizQuestions.length){
      return DiskalkuliaResultScreen();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Menghilangkan shadow AppBar
        leading: IconButton(
          icon: const Icon(Icons.home_rounded, color: Colors.grey, size: 35,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Discalculia(),));
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('SESI', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), ),
            SizedBox(height: 10,),
            LinearProgressIndicator(
              value: progress, // Contoh nilai progress bar
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal[700],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.flutter_dash, color: Colors.white, size: 30), 
                  ),
                  const SizedBox(width: 12),
                  // Bubble chat untuk pertanyaan*********************************************************
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        QuizQuestions[questionIndex].question,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30), // Spasi setelah pertanyaan

              // Daftar pilihan alasan 
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final QuizQuestion = QuizQuestions[questionIndex].answers[index];
                    final isSelected = _selectedAnswer == QuizQuestion;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAnswer = QuizQuestion; // Mengubah pilihan saat diklik
                        });
                        // Di sini Anda bisa menambahkan logika untuk melanjutkan ke layar berikutnya
                        // print('Selected: ${reason.text}');
                      },
                      child: AnswerButton(QuizQuestion, isSelected)
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // Tombol "Continue" di bagian bawah
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _selectedAnswer != null ? () {
            // Logika saat tombol 'Continue' ditekan
            // Misalnya, navigasi ke layar berikutnya atau simpan pilihan
            setState(() {
              questionIndex++;
              progress = progress + 1/QuizQuestions.length;
            });
          } : null, // Tombol nonaktif jika belum ada pilihan
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal, // Warna hijau Duolingo
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: const Text('Continue'),
        ),
      ),
    );
  }
}
