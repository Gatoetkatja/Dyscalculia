import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Model untuk Subtest
class Subtest {
  final int id;
  final String name;
  final String description;
  final List<Question> questions;

  Subtest({
    required this.id,
    required this.name,
    required this.description,
    required this.questions,
  });

  factory Subtest.fromJson(Map<String, dynamic> json) {
    return Subtest(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
    );
  }
}

// Model untuk Question
class Question {
  final int id;
  final String question;
  final List<String> options;
  final int correctAnswer;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correct_answer'],
    );
  }
}

// Model untuk Answer dengan timing
class UserAnswer {
  final int questionId;
  final int selectedAnswer;
  final int timeSpentSeconds;
  final DateTime answeredAt;

  UserAnswer({
    required this.questionId,
    required this.selectedAnswer,
    required this.timeSpentSeconds,
    required this.answeredAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'selected_answer': selectedAnswer,
      'time_spent_seconds': timeSpentSeconds,
      'answered_at': answeredAt.toIso8601String(),
    };
  }
}

// Model untuk Quiz Response
class QuizResponse {
  final bool success;
  final List<Subtest> subtests;
  final String message;

  QuizResponse({
    required this.success,
    required this.subtests,
    required this.message,
  });

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    return QuizResponse(
      success: json['success'],
      subtests: (json['subtests'] as List)
          .map((s) => Subtest.fromJson(s))
          .toList(),
      message: json['message'] ?? '',
    );
  }
}

// Service untuk mengambil data dari API
class QuizService {
  static const String baseUrl = 'https://your-api.com/api';
  
  // Mock data untuk testing
  static QuizResponse getMockData() {
    const String mockJson = '''
    {
      "success": true,
      "message": "Quiz berhasil dimuat",
      "subtests": [
        {
          "id": 1,
          "name": "Kemampuan Menghitung Dasar",
          "description": "Mengukur kemampuan operasi matematika sederhana",
          "questions": [
            {
              "id": 1,
              "question": "Berapa hasil dari 1 + 1?",
              "options": ["1", "2", "3", "4", "5"],
              "correct_answer": 1
            },
            {
              "id": 2,
              "question": "Berapa hasil dari 3 + 2?",
              "options": ["4", "5", "6", "7", "8"],
              "correct_answer": 1
            },
            {
              "id": 3,
              "question": "Berapa hasil dari 4 + 4?",
              "options": ["6", "7", "8", "9", "10"],
              "correct_answer": 2
            }
          ]
        },
        {
          "id": 2,
          "name": "Pengenalan Angka",
          "description": "Mengukur kemampuan mengenali dan membaca angka",
          "questions": [
            {
              "id": 4,
              "question": "Angka mana yang paling besar?",
              "options": ["5", "3", "7", "2", "4"],
              "correct_answer": 2
            },
            {
              "id": 5,
              "question": "Berapa angka setelah 9?",
              "options": ["8", "10", "11", "12", "9"],
              "correct_answer": 1
            }
          ]
        },
        {
          "id": 3,
          "name": "Kemampuan Pengurangan",
          "description": "Mengukur kemampuan operasi pengurangan",
          "questions": [
            {
              "id": 6,
              "question": "Berapa hasil dari 10 - 3?",
              "options": ["6", "7", "8", "9", "5"],
              "correct_answer": 1
            },
            {
              "id": 7,
              "question": "Berapa hasil dari 15 - 8?",
              "options": ["6", "7", "8", "9", "5"],
              "correct_answer": 1
            },
            {
              "id": 8,
              "question": "Berapa hasil dari 20 - 12?",
              "options": ["6", "7", "8", "9", "10"],
              "correct_answer": 2
            }
          ]
        },
        {
          "id": 4,
          "name": "Konsep Waktu",
          "description": "Mengukur pemahaman tentang konsep waktu",
          "questions": [
            {
              "id": 9,
              "question": "Berapa menit dalam 1 jam?",
              "options": ["50", "60", "70", "80", "90"],
              "correct_answer": 1
            },
            {
              "id": 10,
              "question": "Jam berapa setelah jam 11?",
              "options": ["10", "12", "13", "1", "11"],
              "correct_answer": 1
            }
          ]
        },
        {
          "id": 5,
          "name": "Pemahaman Bentuk",
          "description": "Mengukur kemampuan mengenali bentuk geometri",
          "questions": [
            {
              "id": 11,
              "question": "Berapa sisi yang dimiliki segitiga?",
              "options": ["2", "3", "4", "5", "6"],
              "correct_answer": 1
            },
            {
              "id": 12,
              "question": "Berapa sudut yang dimiliki persegi?",
              "options": ["2", "3", "4", "5", "6"],
              "correct_answer": 2
            },
            {
              "id": 13,
              "question": "Bentuk apa yang tidak memiliki sudut?",
              "options": ["Persegi", "Lingkaran", "Segitiga", "Persegi Panjang", "Diamond"],
              "correct_answer": 1
            }
          ]
        }
      ]
    }
    ''';
    
    return QuizResponse.fromJson(json.decode(mockJson));
  }
  
  static Future<QuizResponse> fetchQuiz() async {
    try {
      await Future.delayed(Duration(seconds: 1));
      return getMockData();
    } catch (e) {
      throw Exception('Error fetching quiz: $e');
    }
  }
  
  static Future<bool> submitAnswer(UserAnswer answer) async {
    try {
      // Submit jawaban dengan timing ke API
      await Future.delayed(Duration(milliseconds: 500));
      print('Answer submitted: ${answer.toJson()}');
      return true;
    } catch (e) {
      print('Error submitting answer: $e');
      return false;
    }
  }
  
  static Future<bool> submitSubtestComplete(int subtestId, List<UserAnswer> answers) async {
    try {
      // Submit completion subtest ke API
      await Future.delayed(Duration(milliseconds: 500));
      print('Subtest $subtestId completed with ${answers.length} answers');
      return true;
    } catch (e) {
      print('Error submitting subtest completion: $e');
      return false;
    }
  }
}

class QuizQuestionPage extends StatefulWidget {
  @override
  _QuizQuestionPageState createState() => _QuizQuestionPageState();
}

class _QuizQuestionPageState extends State<QuizQuestionPage>
    with TickerProviderStateMixin {
  int? selectedAnswer;
  int currentSubtestIndex = 0;
  int currentQuestionIndex = 0;
  List<Subtest> subtests = [];
  List<UserAnswer> currentSubtestAnswers = [];
  bool isLoading = true;
  String errorMessage = '';
  
  // Timer untuk tracking waktu
  late Stopwatch _questionStopwatch;
  Timer? _timer;
  int _currentQuestionSeconds = 0;
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeTimer();
    _loadQuestions();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
  }

  void _initializeTimer() {
    _questionStopwatch = Stopwatch();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_questionStopwatch.isRunning) {
        setState(() {
          _currentQuestionSeconds = _questionStopwatch.elapsed.inSeconds;
        });
      }
    });
  }

  void _startQuestionTimer() {
    _questionStopwatch.reset();
    _questionStopwatch.start();
    _currentQuestionSeconds = 0;
  }

  void _stopQuestionTimer() {
    _questionStopwatch.stop();
  }

  Future<void> _loadQuestions() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final quizResponse = await QuizService.fetchQuiz();
      
      if (quizResponse.success && quizResponse.subtests.isNotEmpty) {
        setState(() {
          subtests = quizResponse.subtests;
          isLoading = false;
        });
        _fadeController.forward();
        _startQuestionTimer();
      } else {
        setState(() {
          errorMessage = quizResponse.message.isNotEmpty 
              ? quizResponse.message 
              : 'Tidak ada subtes tersedia';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat soal. Periksa koneksi internet Anda.';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _timer?.cancel();
    _questionStopwatch.stop();
    super.dispose();
  }

  void _selectAnswer(int index) {
    setState(() {
      selectedAnswer = index;
    });
  }

  Future<void> _onContinuePressed() async {
    if (selectedAnswer == null) return;

    _stopQuestionTimer();
    
    final currentQuestion = subtests[currentSubtestIndex].questions[currentQuestionIndex];
    final answer = UserAnswer(
      questionId: currentQuestion.id,
      selectedAnswer: selectedAnswer!,
      timeSpentSeconds: _currentQuestionSeconds,
      answeredAt: DateTime.now(),
    );

    // Submit jawaban ke API
    final isSubmitted = await QuizService.submitAnswer(answer);
    if (!isSubmitted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan jawaban. Silakan coba lagi.'),
          backgroundColor: Colors.red,
        ),
      );
      _startQuestionTimer(); // Restart timer jika gagal
      return;
    }

    // Simpan jawaban ke list
    currentSubtestAnswers.add(answer);

    final currentSubtest = subtests[currentSubtestIndex];
    
    // Cek apakah masih ada soal di subtes ini
    if (currentQuestionIndex < currentSubtest.questions.length - 1) {
      // Pindah ke soal berikutnya di subtes yang sama
      _fadeController.reset();
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
      });
      _fadeController.forward();
      _startQuestionTimer();
    } else {
      // Subtes selesai, submit completion
      await QuizService.submitSubtestComplete(currentSubtest.id, currentSubtestAnswers);
      
      // Cek apakah masih ada subtes berikutnya
      if (currentSubtestIndex < subtests.length - 1) {
        // Pindah ke subtes berikutnya
        _showSubtestComplete();
      } else {
        // Semua subtes selesai
        _showQuizComplete();
      }
    }
  }

  void _showSubtestComplete() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Subtes Selesai!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 48),
            SizedBox(height: 16),
            Text(
              'Anda telah menyelesaikan subtes "${subtests[currentSubtestIndex].name}"',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Subtes ${currentSubtestIndex + 1} dari ${subtests.length}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _moveToNextSubtest();
            },
            child: Text('Lanjut ke Subtes Berikutnya'),
          ),
        ],
      ),
    );
  }

  void _moveToNextSubtest() {
    _fadeController.reset();
    setState(() {
      currentSubtestIndex++;
      currentQuestionIndex = 0;
      selectedAnswer = null;
      currentSubtestAnswers.clear();
    });
    _fadeController.forward();
    _startQuestionTimer();
  }

  void _showQuizComplete() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Tes Selesai!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, color: Colors.amber, size: 48),
            SizedBox(height: 16),
            Text(
              'Selamat! Anda telah menyelesaikan semua subtes.',
              textAlign: TextAlign.center,
            ),
            Text(
              'Total: ${subtests.length} subtes',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('Lihat Hasil'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF27AE60)),
              ),
              SizedBox(height: 16),
              Text(
                'Memuat subtes...',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
              SizedBox(height: 16),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadQuestions,
                child: Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF27AE60),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (subtests.isEmpty) {
      return Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        body: Center(child: Text('Tidak ada subtes tersedia')),
      );
    }

    final currentSubtest = subtests[currentSubtestIndex];
    final currentQuestion = currentSubtest.questions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFF5F7FA),
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black87, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SUBTES ${currentSubtestIndex + 1}/5',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              currentSubtest.name,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer, size: 16, color: Colors.orange[700]),
                SizedBox(width: 4),
                Text(
                  _formatTime(_currentQuestionSeconds),
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress Bar untuk soal dalam subtes
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Soal ${currentQuestionIndex + 1} dari ${currentSubtest.questions.length}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${((currentQuestionIndex + 1) / currentSubtest.questions.length * 100).round()}%',
                            style: TextStyle(
                              color: Color(0xFF27AE60),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: (currentQuestionIndex + 1) / currentSubtest.questions.length,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF27AE60),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24),

                // Question Section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF6C63FF), Color(0xFF4834D4)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(Icons.quiz, color: Colors.white, size: 28),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              currentQuestion.question,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Pilih jawaban yang benar dari pilihan di bawah ini:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                // Answer Options
                ...List.generate(currentQuestion.options.length, (index) {
                  final colors = [
                    [Color(0xFF3498DB), Color(0xFF2980B9)], // Blue
                    [Color(0xFF2ECC71), Color(0xFF27AE60)], // Green
                    [Color(0xFF9B59B6), Color(0xFF8E44AD)], // Purple
                    [Color(0xFFF39C12), Color(0xFFD35400)], // Yellow/Gold
                    [Color(0xFF1ABC9C), Color(0xFF16A085)], // Teal
                  ];

                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _selectAnswer(index),
                        borderRadius: BorderRadius.circular(20),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: selectedAnswer == index
                                ? LinearGradient(
                                    colors: colors[index % colors.length],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            color: selectedAnswer == index ? null : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selectedAnswer == index
                                  ? Colors.transparent
                                  : Colors.grey[200]!,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: selectedAnswer == index
                                    ? colors[index % colors.length][0].withOpacity(0.3)
                                    : Colors.black.withOpacity(0.05),
                                blurRadius: selectedAnswer == index ? 15 : 10,
                                offset: Offset(0, selectedAnswer == index ? 8 : 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: selectedAnswer == index
                                      ? Colors.white.withOpacity(0.2)
                                      : Colors.grey[100],
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selectedAnswer == index
                                        ? Colors.white
                                        : Colors.grey[300]!,
                                    width: 2,
                                  ),
                                ),
                                child: selectedAnswer == index
                                    ? Icon(Icons.check, size: 16, color: Colors.white)
                                    : null,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  currentQuestion.options[index],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: selectedAnswer == index
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),

                SizedBox(height: 40),

                // Continue Button
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedAnswer != null ? _onContinuePressed : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF27AE60),
                      disabledBackgroundColor: Colors.grey[300],
                      padding: EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: selectedAnswer != null ? 8 : 2,
                      shadowColor: Color(0xFF27AE60).withOpacity(0.4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (currentQuestionIndex < currentSubtest.questions.length - 1)
                              ? 'Lanjutkan'
                              : (currentSubtestIndex < subtests.length - 1)
                                  ? 'Selesaikan Subtes'
                                  : 'Selesai',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          (currentQuestionIndex < currentSubtest.questions.length - 1)
                              ? Icons.arrow_forward
                              : Icons.check,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Main app to run the quiz page
class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dyscalculia Test',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: QuizQuestionPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  runApp(QuizApp());
}