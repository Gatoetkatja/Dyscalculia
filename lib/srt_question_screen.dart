import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Enum untuk tipe question
enum QuestionType { multipleChoice, srt }

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

// Model untuk Question yang sudah dimodifikasi
class Question {
  final int id;
  final String question;
  final List<String>? options;
  final int? correctAnswer;
  final QuestionType type;

  Question({
    required this.id,
    required this.question,
    this.options,
    this.correctAnswer,
    required this.type,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      options: json['options'] != null ? List<String>.from(json['options']) : null,
      correctAnswer: json['correct_answer'],
      type: json['type'] == 'srt' ? QuestionType.srt : QuestionType.multipleChoice,
    );
  }
}

// Model untuk Answer dengan timing - ditambah field untuk multiple reaction times
class UserAnswer {
  final int questionId;
  final int? selectedAnswer;
  final double? reactionTime; // Untuk SRT (rata-rata)
  final List<double>? allReactionTimes; // Untuk menyimpan semua 5 waktu reaksi SRT
  final int timeSpentSeconds;
  final DateTime answeredAt;

  UserAnswer({
    required this.questionId,
    this.selectedAnswer,
    this.reactionTime,
    this.allReactionTimes,
    required this.timeSpentSeconds,
    required this.answeredAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'selected_answer': selectedAnswer,
      'reaction_time': reactionTime,
      'all_reaction_times': allReactionTimes,
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
  
  // Mock data untuk testing dengan SRT questions
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
              "correct_answer": 1,
              "type": "multiple_choice"
            },
            {
              "id": 2,
              "question": "Berapa hasil dari 3 + 2?",
              "options": ["4", "5", "6", "7", "8"],
              "correct_answer": 1,
              "type": "multiple_choice"
            }
          ]
        },
        {
          "id": 2,
          "name": "Tes Waktu Reaksi",
          "description": "Mengukur waktu reaksi visual",
          "questions": [
            {
              "id": 3,
              "question": "Ketuk layar ketika lingkaran hitam muncul",
              "type": "srt"
            },
            {
              "id": 4,
              "question": "Ketuk layar ketika lingkaran hitam muncul",
              "type": "srt"
            },
            {
              "id": 5,
              "question": "Ketuk layar ketika lingkaran hitam muncul",
              "type": "srt"
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
              "correct_answer": 1,
              "type": "multiple_choice"
            },
            {
              "id": 7,
              "question": "Berapa hasil dari 15 - 8?",
              "options": ["6", "7", "8", "9", "5"],
              "correct_answer": 1,
              "type": "multiple_choice"
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
      await Future.delayed(Duration(milliseconds: 500));
      print('Subtest $subtestId completed with ${answers.length} answers');
      return true;
    } catch (e) {
      print('Error submitting subtest completion: $e');
      return false;
    }
  }
}

// SRT Widget yang sudah dimodifikasi - 5 kali pengujian
class SrtWidget extends StatefulWidget {
  final Function(double?) onReactionTime;
  final Function(List<double>)? onAllReactionTimes; // Callback untuk semua waktu reaksi
  final VoidCallback? onCompleted;

  SrtWidget({
    required this.onReactionTime, 
    this.onAllReactionTimes,
    this.onCompleted
  });

  @override
  _SrtWidgetState createState() => _SrtWidgetState();
}

class _SrtWidgetState extends State<SrtWidget> {
  bool _showCircle = false;
  String _statusText = "Ketuk di mana saja untuk memulai";
  DateTime? _startTime;
  Timer? _waitTimer;
  bool _testStarted = false;
  bool _allTestsCompleted = false;

  double _randomTop = 0;
  double _randomLeft = 0;

  // Variables untuk 5x pengujian
  int _currentAttempt = 0;
  List<double> _reactionTimes = [];
  static const int _totalAttempts = 5;

  void _startTest() {
    if (_allTestsCompleted) return;
    
    _waitTimer?.cancel();
    
    final screenSize = MediaQuery.of(context).size;
    final circleSize = 100.0;
    
    final newTop = Random().nextDouble() * (screenSize.height - circleSize - 200);
    final newLeft = Random().nextDouble() * (screenSize.width - circleSize);

    setState(() {
      _statusText = "Tunggu lingkaran hitam muncul...";
      _showCircle = false;
      _testStarted = true;
      _randomTop = newTop;
      _randomLeft = newLeft;
    });

    int delay = Random().nextInt(3000) + 2000; // 2-5 detik
    _waitTimer = Timer(Duration(milliseconds: delay), () {
      if (mounted) {
        setState(() {
          _showCircle = true;
          _startTime = DateTime.now();
          _statusText = "TEKAN SEKARANG!";
        });
      }
    });
  }

  void _userReacted() {
    if (_allTestsCompleted) return;
    
    if (!_testStarted) {
      _startTest();
    } else if (_showCircle) {
      DateTime endTime = DateTime.now();
      double reactionTime = endTime.difference(_startTime!).inMilliseconds / 1000;
      
      _reactionTimes.add(reactionTime);
      _currentAttempt++;
      
      setState(() {
        _showCircle = false;
        _testStarted = false;
      });
      
      if (_currentAttempt < _totalAttempts) {
        // Masih ada percobaan lagi
        setState(() {
          _statusText = "Percobaan ${_currentAttempt}/$_totalAttempts selesai!\n"
                       "Waktu: ${reactionTime.toStringAsFixed(3)} detik\n"
                       "Ketuk untuk percobaan berikutnya";
        });
        
        // Auto start next attempt after 2 seconds
        Timer(Duration(seconds: 2), () {
          if (mounted && !_allTestsCompleted) {
            _startTest();
          }
        });
      } else {
        // Semua percobaan selesai
        double averageTime = _reactionTimes.reduce((a, b) => a + b) / _reactionTimes.length;
        
        setState(() {
          _allTestsCompleted = true;
          _statusText = "Semua percobaan selesai!\n"
                       "Rata-rata waktu reaksi: ${averageTime.toStringAsFixed(3)} detik\n"
                       "Ketuk untuk melanjutkan";
        });
        
        // Callback dengan rata-rata waktu reaksi
        widget.onReactionTime(averageTime);
        
        // Callback dengan semua waktu reaksi jika diperlukan
        if (widget.onAllReactionTimes != null) {
          widget.onAllReactionTimes!(_reactionTimes);
        }
        
        // Auto continue after 3 seconds
        Timer(Duration(seconds: 3), () {
          if (widget.onCompleted != null) {
            widget.onCompleted!();
          }
        });
      }
    } else {
      _waitTimer?.cancel();
      setState(() {
        _statusText = "Terlalu cepat! Ketuk lagi untuk memulai ulang.";
        _testStarted = false;
      });
    }
  }

  @override
  void dispose() {
    _waitTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _userReacted,
      child: Container(
        width: double.infinity,
        height: 450, // Tinggi diperbesar untuk menampung info lebih banyak
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
        child: Stack(
          children: [
            // Status Text
            Positioned(
              left: 20,
              right: 20,
              top: 30,
              child: Text(
                _statusText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _allTestsCompleted ? Colors.green : Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
            
            // Progress indicator
            if (_currentAttempt > 0 && !_allTestsCompleted)
              Positioned(
                left: 20,
                right: 20,
                top: 120,
                child: Column(
                  children: [
                    Text(
                      'Percobaan ${_currentAttempt}/$_totalAttempts',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _currentAttempt / _totalAttempts,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF27AE60)),
                    ),
                  ],
                ),
              ),
            
            // Results summary when all tests completed
            if (_allTestsCompleted)
              Positioned(
                left: 20,
                right: 20,
                top: 120,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hasil Lengkap:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.green[800],
                        ),
                      ),
                      SizedBox(height: 8),
                      ...List.generate(_reactionTimes.length, (index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Percobaan ${index + 1}:',
                                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                              ),
                              Text(
                                '${_reactionTimes[index].toStringAsFixed(3)} detik',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      Divider(thickness: 1, color: Colors.green[300]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rata-rata:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.green[800],
                            ),
                          ),
                          Text(
                            '${(_reactionTimes.reduce((a, b) => a + b) / _reactionTimes.length).toStringAsFixed(3)} detik',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.green[800],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            
            // Circle
            if (_showCircle)
              Positioned(
                top: _randomTop + 80,
                left: _randomLeft,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SrtQuizPage extends StatefulWidget {
  @override
  SrtQuizPageState createState() => SrtQuizPageState();
}

class SrtQuizPageState extends State<SrtQuizPage>
    with TickerProviderStateMixin {
  int? selectedAnswer;
  double? srtReactionTime;
  List<double>? allSrtReactionTimes; // Menyimpan semua 5 waktu reaksi
  int currentSubtestIndex = 0;
  int currentQuestionIndex = 0;
  List<Subtest> subtests = [];
  List<UserAnswer> currentSubtestAnswers = [];
  bool isLoading = true;
  String errorMessage = '';
  
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

  void _onSrtReactionTime(double? reactionTime) {
    setState(() {
      srtReactionTime = reactionTime;
    });
  }

  void _onAllSrtReactionTimes(List<double> reactionTimes) {
    setState(() {
      allSrtReactionTimes = reactionTimes;
    });
  }

  void _onSrtCompleted() {
    _onContinuePressed();
  }

  Future<void> _onContinuePressed() async {
    final currentQuestion = subtests[currentSubtestIndex].questions[currentQuestionIndex];
    
    // Validasi berdasarkan tipe question
    if (currentQuestion.type == QuestionType.multipleChoice && selectedAnswer == null) {
      return;
    }
    if (currentQuestion.type == QuestionType.srt && srtReactionTime == null) {
      return;
    }

    _stopQuestionTimer();
    
    final answer = UserAnswer(
      questionId: currentQuestion.id,
      selectedAnswer: currentQuestion.type == QuestionType.multipleChoice ? selectedAnswer : null,
      reactionTime: currentQuestion.type == QuestionType.srt ? srtReactionTime : null,
      allReactionTimes: currentQuestion.type == QuestionType.srt ? allSrtReactionTimes : null,
      timeSpentSeconds: _currentQuestionSeconds,
      answeredAt: DateTime.now(),
    );

    final isSubmitted = await QuizService.submitAnswer(answer);
    if (!isSubmitted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan jawaban. Silakan coba lagi.'),
          backgroundColor: Colors.red,
        ),
      );
      _startQuestionTimer();
      return;
    }

    currentSubtestAnswers.add(answer);
    final currentSubtest = subtests[currentSubtestIndex];
    
    if (currentQuestionIndex < currentSubtest.questions.length - 1) {
      _fadeController.reset();
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        srtReactionTime = null;
        allSrtReactionTimes = null;
      });
      _fadeController.forward();
      _startQuestionTimer();
    } else {
      await QuizService.submitSubtestComplete(currentSubtest.id, currentSubtestAnswers);
      
      if (currentSubtestIndex < subtests.length - 1) {
        _showSubtestComplete();
      } else {
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
      srtReactionTime = null;
      allSrtReactionTimes = null;
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

  Widget _buildQuestionContent() {
    final currentQuestion = subtests[currentSubtestIndex].questions[currentQuestionIndex];
    
    if (currentQuestion.type == QuestionType.srt) {
      return Column(
        children: [
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
                          colors: [Color(0xFFE74C3C), Color(0xFFC0392B)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.timer, color: Colors.white, size: 28),
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
                  'Tes waktu reaksi visual. Ketuk layar dengan cepat ketika lingkaran hitam muncul.',
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
          SrtWidget(
            onReactionTime: _onSrtReactionTime,
            onAllReactionTimes: _onAllSrtReactionTimes,
            onCompleted: _onSrtCompleted,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          // Multiple Choice Question Content
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
          ...List.generate(currentQuestion.options!.length, (index) {
            final colors = [
              [Color(0xFF3498DB), Color(0xFF2980B9)],
              [Color(0xFF2ECC71), Color(0xFF27AE60)],
              [Color(0xFF9B59B6), Color(0xFF8E44AD)],
              [Color(0xFFF39C12), Color(0xFFD35400)],
              [Color(0xFF1ABC9C), Color(0xFF16A085)],
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
                            currentQuestion.options![index],
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
          // Continue Button untuk Multiple Choice
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
                    (currentQuestionIndex < subtests[currentSubtestIndex].questions.length - 1)
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
                    (currentQuestionIndex < subtests[currentSubtestIndex].questions.length - 1)
                        ? Icons.arrow_forward
                        : Icons.check,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
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
              'SUBTES ${currentSubtestIndex + 1}/${subtests.length}',
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

                // Dynamic Question Content berdasarkan tipe
                _buildQuestionContent(),
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
      home: SrtQuizPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  runApp(QuizApp());
}