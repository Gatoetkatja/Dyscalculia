import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

/// Model untuk menyimpan hasil SRT test
class SrtResult {
  final List<double> reactionTimes;
  final double averageTime;
  final bool completed;
  
  SrtResult({
    required this.reactionTimes,
    required this.averageTime,
    required this.completed,
  });
}

/// Simple Reaction Time (SRT) Test Widget
/// 
/// Widget ini melakukan tes waktu reaksi sederhana dengan 5 kali percobaan.
/// Pengguna harus menunggu lingkaran hitam muncul, kemudian mengetuknya secepat mungkin.
class SrtWidget extends StatefulWidget {
  /// Callback yang dipanggil ketika rata-rata waktu reaksi tersedia
  final Function(double?)? onReactionTime;
  
  /// Callback yang dipanggil dengan semua waktu reaksi individual
  final Function(List<double>)? onAllReactionTimes;
  
  /// Callback yang dipanggil ketika semua tes selesai
  final VoidCallback? onCompleted;
  
  /// Callback yang dipanggil dengan hasil lengkap
  final Function(SrtResult)? onResult;
  
  /// Jumlah percobaan yang akan dilakukan (default: 5)
  final int totalAttempts;
  
  /// Apakah akan otomatis lanjut ke percobaan berikutnya (default: true)
  final bool autoNextAttempt;
  
  /// Delay minimum sebelum lingkaran muncul dalam milidetik (default: 2000)
  final int minDelayMs;
  
  /// Delay maksimum sebelum lingkaran muncul dalam milidetik (default: 5000)
  final int maxDelayMs;

  const SrtWidget({
    Key? key,
    this.onReactionTime,
    this.onAllReactionTimes,
    this.onCompleted,
    this.onResult,
    this.totalAttempts = 5,
    this.autoNextAttempt = true,
    this.minDelayMs = 2000,
    this.maxDelayMs = 5000,
  }) : super(key: key);

  @override
  State<SrtWidget> createState() => _SrtWidgetState();
}

class _SrtWidgetState extends State<SrtWidget> {
  // State variables
  bool _showCircle = false;
  String _statusText = "Ketuk di mana saja untuk memulai";
  DateTime? _startTime;
  Timer? _waitTimer;
  bool _testStarted = false;
  bool _allTestsCompleted = false;
  bool _tooEarly = false;

  // Position variables untuk lingkaran
  double _randomTop = 0.0;
  double _randomLeft = 0.0;

  // Test progress variables
  int _currentAttempt = 0;
  List<double> _reactionTimes = [];

  @override
  void initState() {
    super.initState();
    _initializeTest();
  }

  @override
  void dispose() {
    _waitTimer?.cancel();
    super.dispose();
  }

  void _initializeTest() {
    setState(() {
      _currentAttempt = 0;
      _reactionTimes.clear();
      _allTestsCompleted = false;
      _testStarted = false;
      _showCircle = false;
      _tooEarly = false;
      _statusText = "Ketuk di mana saja untuk memulai";
    });
  }

  void _startTest() {
    if (_allTestsCompleted) return;
    
    _waitTimer?.cancel();
    
    // Generate random position untuk lingkaran
    final screenSize = MediaQuery.of(context).size;
    const double circleSize = 100.0;
    const double safeAreaTop = 100.0; // Space untuk status text
    const double safeAreaBottom = 100.0; // Space di bawah
    
    final double maxTop = screenSize.height - circleSize - safeAreaTop - safeAreaBottom;
    final double maxLeft = screenSize.width - circleSize;
    
    final double newTop = maxTop > 0 ? Random().nextDouble() * maxTop : 0.0;
    final double newLeft = maxLeft > 0 ? Random().nextDouble() * maxLeft : 0.0;

    setState(() {
      _statusText = "Tunggu lingkaran hitam muncul...";
      _showCircle = false;
      _testStarted = true;
      _tooEarly = false;
      _randomTop = newTop;
      _randomLeft = newLeft;
    });

    // Random delay antara minDelayMs dan maxDelayMs
    int delay = Random().nextInt(widget.maxDelayMs - widget.minDelayMs) + widget.minDelayMs;
    
    _waitTimer = Timer(Duration(milliseconds: delay), () {
      if (mounted && _testStarted) {
        setState(() {
          _showCircle = true;
          _startTime = DateTime.now();
          _statusText = "TEKAN SEKARANG!";
        });
      }
    });
  }

  void _userReacted() {
    if (_allTestsCompleted) {
      // Jika semua tes sudah selesai, panggil callback completion
      if (widget.onCompleted != null) {
        widget.onCompleted!();
      }
      return;
    }
    
    if (!_testStarted) {
      // Mulai tes pertama kali
      _startTest();
    } else if (_showCircle && _startTime != null) {
      // User bereaksi ketika lingkaran terlihat - ini yang kita inginkan
      DateTime endTime = DateTime.now();
      double reactionTime = endTime.difference(_startTime!).inMilliseconds / 1000.0;
      
      _reactionTimes.add(reactionTime);
      _currentAttempt++;
      
      _waitTimer?.cancel();
      
      setState(() {
        _showCircle = false;
        _testStarted = false;
      });
      
      if (_currentAttempt < widget.totalAttempts) {
        // Masih ada percobaan lagi
        setState(() {
          _statusText = "Percobaan ${_currentAttempt}/${widget.totalAttempts} selesai!\n"
                       "Waktu: ${reactionTime.toStringAsFixed(3)} detik\n"
                       "${widget.autoNextAttempt ? 'Bersiap untuk percobaan berikutnya...' : 'Ketuk untuk percobaan berikutnya'}";
        });
        
        if (widget.autoNextAttempt) {
          // Auto start next attempt after 2 seconds
          Timer(Duration(seconds: 2), () {
            if (mounted && !_allTestsCompleted) {
              _startTest();
            }
          });
        }
      } else {
        // Semua percobaan selesai
        _completeAllTests();
      }
    } else {
      // User menekan terlalu cepat
      _waitTimer?.cancel();
      setState(() {
        _statusText = "Terlalu cepat! Tunggu lingkaran hitam muncul.\nKetuk untuk mencoba lagi.";
        _testStarted = false;
        _showCircle = false;
        _tooEarly = true;
      });
    }
  }

  void _completeAllTests() {
    double averageTime = _reactionTimes.reduce((a, b) => a + b) / _reactionTimes.length;
    
    setState(() {
      _allTestsCompleted = true;
      _statusText = "Semua percobaan selesai!\n"
                   "Rata-rata waktu reaksi: ${averageTime.toStringAsFixed(3)} detik\n"
                   "Ketuk untuk melanjutkan";
    });
    
    // Create result object
    final result = SrtResult(
      reactionTimes: List.from(_reactionTimes),
      averageTime: averageTime,
      completed: true,
    );
    
    // Call all callbacks
    if (widget.onReactionTime != null) {
      widget.onReactionTime!(averageTime);
    }
    
    if (widget.onAllReactionTimes != null) {
      widget.onAllReactionTimes!(_reactionTimes);
    }
    
    if (widget.onResult != null) {
      widget.onResult!(result);
    }
    
    // Auto continue after 3 seconds jika ada callback completion
    if (widget.onCompleted != null) {
      Timer(Duration(seconds: 3), () {
        if (mounted && widget.onCompleted != null) {
          widget.onCompleted!();
        }
      });
    }
  }

  Color _getStatusColor() {
    if (_allTestsCompleted) return Colors.green;
    if (_tooEarly) return Colors.red;
    if (_showCircle) return Colors.orange;
    return Colors.black87;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _userReacted,
      child: Container(
        width: double.infinity,
        height: 450,
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
                  color: _getStatusColor(),
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
                      'Percobaan ${_currentAttempt}/${widget.totalAttempts}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _currentAttempt / widget.totalAttempts,
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
                            '${_reactionTimes.isNotEmpty ? (_reactionTimes.reduce((a, b) => a + b) / _reactionTimes.length).toStringAsFixed(3) : '0.000'} detik',
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
            
            // Circle that appears for reaction time test
            if (_showCircle)
              Positioned(
                top: _randomTop + 80, // Offset untuk memberi ruang pada status text
                left: _randomLeft,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
            
            // Instructions overlay when not started
            if (!_testStarted && _currentAttempt == 0 && !_allTestsCompleted)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: Colors.blue[700], size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Instruksi:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.blue[800],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• Tunggu hingga lingkaran hitam muncul\n'
                        '• Ketuk lingkaran secepat mungkin\n'
                        '• Jangan ketuk sebelum lingkaran muncul\n'
                        '• Akan ada ${widget.totalAttempts} percobaan',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Example usage widget
class SrtTestPage extends StatefulWidget {
  @override
  State<SrtTestPage> createState() => _SrtTestPageState();
}

class _SrtTestPageState extends State<SrtTestPage> {
  SrtResult? _result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text('Simple Reaction Time Test'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tes Waktu Reaksi',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Mengukur waktu reaksi visual Anda',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // SRT Widget
            SrtWidget(
              totalAttempts: 5,
              autoNextAttempt: true,
              onResult: (result) {
                setState(() {
                  _result = result;
                });
              },
              onCompleted: () {
                // Handle completion - bisa navigate ke halaman berikutnya
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tes selesai! Rata-rata: ${_result?.averageTime.toStringAsFixed(3)} detik'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
            
            // Result display (optional)
            if (_result != null)
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistik Hasil:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Rata-rata: ${_result!.averageTime.toStringAsFixed(3)} detik'),
                    Text('Tercepat: ${_result!.reactionTimes.reduce((a, b) => a < b ? a : b).toStringAsFixed(3)} detik'),
                    Text('Terlambat: ${_result!.reactionTimes.reduce((a, b) => a > b ? a : b).toStringAsFixed(3)} detik'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}