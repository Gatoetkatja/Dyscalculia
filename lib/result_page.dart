import 'package:flutter/material.dart';
import 'dart:convert';

class DiskalkuliaResultScreen extends StatefulWidget {
  @override
  _DiskalkuliaResultScreenState createState() => _DiskalkuliaResultScreenState();
}

class _DiskalkuliaResultScreenState extends State<DiskalkuliaResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _chartController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _chartAnimation;


  final Map<String, dynamic> res = jsonDecode(
    '''{
    "diagnosis": 2,
    "label": {
        "diagnosis": {
            "0": "Normal",
            "1": "Diskalkulia",
            "2": "Keterampilan Aritmatika yang Buruk"
        },
        "skor": [
            "Menghitung Titik",
            "Perbandingan Angka",
            "Pertambahan",
            "Perkalian",
            "Pengurangan"
        ]
    },
    "probabilitas": {
        "0": 0.04,
        "1": 0.43,
        "2": 0.56
    },
    "skor": [
        3.41,
        3.3,
        5.23,
        1.58,
        1.87
    ]
}'''
  );
  // Data untuk chart
  final List<Map<String, dynamic>> chartData = [
    {'label': 'Dot', 'value': 6.2, 'color': Color(0xFF2196F3)},
    {'label': 'Stroop', 'value': 4.8, 'color': Color(0xFFFF9800)},
    {'label': 'Add', 'value': 8.3, 'color': Color(0xFF9C27B0)},
    {'label': 'Mult', 'value': 7.3, 'color': Color(0xFFE91E63)},
    {'label': 'Sub', 'value': 8.0, 'color': Color(0xFF00BCD4)},
  ];

  final List<Map<String, dynamic>> result = [
    {'value': 'Kamu kemungkinan normal', 'color': Colors.lightGreen},
    { 'value': 'KEMUNGKINAN kemungkinan DISKALKULIA', 'color': Colors.red},
    { 'value': 'kemu kemungkinan memiliki skill aritmatika yang buruk', 'color': Colors.orange},
  ];

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _chartController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _chartAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _chartController, curve: Curves.elasticOut),
    );

    // Start animations
    _fadeController.forward();
    Future.delayed(Duration(milliseconds: 200), () => _slideController.forward());
    Future.delayed(Duration(milliseconds: 400), () => _chartController.forward());
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _chartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFF7FAFC), Color(0xFFEDF2F7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'Hasil Tes Diskalkulia',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Chart Section
                        SlideTransition(
                          position: _slideAnimation,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFF7FAFC), Color(0xFFEDF2F7)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Skor Subtes',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 20),
                                
                                // Chart
                                Container(
                                  child: AnimatedBuilder(
                                    animation: _chartAnimation,
                                    builder: (context, child) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: chartData.asMap().entries.map((entry) {
                                          
                                          return _buildChartBar(
                                            label: chartData[entry.key]['label'],
                                            value: res['skor'][entry.key],
                                            color: chartData[entry.key]['color'],
                                            maxValue: 10.0,
                                            animationValue: _chartAnimation.value,
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 32),
                        
                        // Result Section
                        SlideTransition(
                          position: _slideAnimation,
                          child: Container(
                            padding: EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [result[0]['color'], result[0]['color']],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF4299E1).withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double containerWidth = constraints.maxWidth;

                                return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kemungkinan Mengalami Diskalkulia',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                
                                // Progress Bar
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Stack(
                                    children: [
                                      AnimatedBuilder(
                                        animation: _chartAnimation,
                                        builder: (context, child) {
                                          return Container(
                                            width: containerWidth * 0.05 * _chartAnimation.value,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [Colors.white, const Color.fromARGB(255, 184, 184, 184)],
                                              ),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          );
                                        },
                                      ),
                                      Container(
                                        height: 40,
                                        alignment: Alignment.center,
                                        child: AnimatedBuilder(
                                          animation: _chartAnimation,
                                          builder: (context, child) {
                                            return Text(
                                              '${5 *(_chartAnimation.value).toInt()}%',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                SizedBox(height: 20),
                                Text(result[0]['value'], style: TextStyle(color: Colors.white),), //********************************* */
                                SizedBox(height: 20),
                                
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Catatan: Hasil ini adalah estimasi dan bukan diagnosis medis. Konsultasikan dengan profesional untuk penilaian lebih lanjut.',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.9),
                                            fontSize: 14,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                              },)
                          ),
                        ),
                        
                        SizedBox(height: 32),
                        
                        // Action Buttons
                        SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Action untuk konsultasi
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF1DB584),
                                    foregroundColor: Colors.white,
                                    elevation: 8,
                                    shadowColor: Color(0xFF1DB584).withOpacity(0.3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.medical_services),
                                      SizedBox(width: 8),
                                      Text(
                                        'Konsultasi Profesional',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              SizedBox(height: 16),
                              
                              Container(
                                width: double.infinity,
                                height: 56,
                                child: OutlinedButton(
                                  onPressed: () {
                                    // Action untuk tes ulang
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Color(0xFF1DB584),
                                    side: BorderSide(color: Color(0xFF1DB584), width: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.refresh),
                                      SizedBox(width: 8),
                                      Text(
                                        'Ulangi Tes',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartBar({
    required String label,
    required double value,
    required Color color,
    required double maxValue,
    required double animationValue,
  }) {
    double barHeight = (value / maxValue) * 160 * animationValue;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Value label
        Container(
          margin: EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        
        // Bar
        Container(
          width: 30,
          height: barHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                color,
                color.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 8),
        
        // Label
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A5568),
          ),
        ),
      ],
    );
  }
}