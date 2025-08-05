import 'package:flutter/material.dart';

class QuizQuestionPage extends StatefulWidget {
  @override
  _QuizQuestionPageState createState() => _QuizQuestionPageState();
}

class _QuizQuestionPageState extends State<QuizQuestionPage>
    with TickerProviderStateMixin {
  int? selectedAnswer;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    setState(() {
      selectedAnswer = index;
    });
  }

  void _onContinuePressed() {
    // Navigate to results or next question
    print("Continue pressed with answer: $selectedAnswer");
  }

  @override
  Widget build(BuildContext context) {
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
          child: Icon(
            Icons.arrow_back,
            color: Colors.black87,
            size: 20,
          ),
        ),
        title: Text(
          'SESI',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                            child: Icon(
                              Icons.quiz,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          SizedBox(width: 16),
                          Text(
                            '1+1?',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
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
                ...List.generate(5, (index) {
                  final answers = ['1', '2', '3', '4', '5'];
                  final colors = [
                    [Color(0xFF3498DB), Color(0xFF2980B9)], // Blue
                    [Color(0xFFFF9500), Color(0xFFE67E22)], // Orange
                    [Color(0xFF9B59B6), Color(0xFF8E44AD)], // Purple
                    [Color(0xFFE91E63), Color(0xFFC2185B)], // Pink
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
                                    colors: colors[index],
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
                                    ? colors[index][0].withOpacity(0.3)
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
                                    ? Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              SizedBox(width: 16),
                              Text(
                                answers[index],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: selectedAnswer == index
                                      ? Colors.white
                                      : Colors.black87,
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
                        Icon(
                          Icons.medical_services,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Lanjutkan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Retry Button
                Container(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        selectedAnswer = null;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xFF27AE60), width: 2),
                      padding: EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh,
                          color: Color(0xFF27AE60),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Ulangi Tes',  
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF27AE60),
                          ),
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