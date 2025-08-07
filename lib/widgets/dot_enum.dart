import 'package:flutter/material.dart';
import 'dart:math';

class RandomDotsDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Positioned Dots'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ganti nilai dotCount sesuai kebutuhan Anda
            RandomDotsWidget(dotCount: 15), // <-- Ubah angka ini untuk jumlah dots
            SizedBox(height: 20,),
            Text('Ada berapa titik yang dapat kamu lihat?')
            
          ],
        ),
      ),
    );
  }
}

class DotPosition {
  final double x;
  final double y;
  
  DotPosition(this.x, this.y);
}

class RandomDotsWidget extends StatefulWidget {
  final int dotCount;
  final double dotSize;
  final Color dotColor;
  final double boxWidth;
  final double boxHeight;
  final double minSpacing;

  const RandomDotsWidget({
    Key? key,
    required this.dotCount,
    this.dotSize = 12.0,
    this.dotColor = Colors.black,
    this.boxWidth = 300.0,
    this.boxHeight = 200.0,
    this.minSpacing = 4.0,
  }) : super(key: key);

  @override
  _RandomDotsWidgetState createState() => _RandomDotsWidgetState();
}

class _RandomDotsWidgetState extends State<RandomDotsWidget> {
  List<DotPosition> dotPositions = [];
  Random random = Random();

  @override
  void initState() {
    super.initState();
    _generateRandomPositions();
  }

  void _generateRandomPositions() {
    dotPositions.clear();
    int attempts = 0;
    int maxAttempts = 1000; // Maksimal percobaan untuk mencegah infinite loop
    
    while (dotPositions.length < widget.dotCount && attempts < maxAttempts) {
      attempts++;
      
      // Generate posisi acak dalam batas box
      double x = random.nextDouble() * (widget.boxWidth - widget.dotSize);
      double y = random.nextDouble() * (widget.boxHeight - widget.dotSize);
      
      // Cek apakah posisi ini bertabrakan dengan dots yang sudah ada
      bool hasCollision = false;
      
      for (DotPosition existingDot in dotPositions) {
        double distance = _calculateDistance(x, y, existingDot.x, existingDot.y);
        double minDistance = widget.dotSize + widget.minSpacing;
        
        if (distance < minDistance) {
          hasCollision = true;
          break;
        }
      }
      
      // Jika tidak ada tabrakan, tambahkan dot
      if (!hasCollision) {
        dotPositions.add(DotPosition(x, y));
      }
    }
    
    // Jika tidak bisa menempatkan semua dots, tampilkan peringatan
    if (dotPositions.length < widget.dotCount) {
      debugPrint('Warning: Hanya bisa menempatkan ${dotPositions.length} dari ${widget.dotCount} dots. Box mungkin terlalu kecil.');
    }
  }

  double _calculateDistance(double x1, double y1, double x2, double y2) {
    return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.boxWidth,
      height: widget.boxHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),]
      ),
      child: Stack(
        children: dotPositions.map((position) {
          return Positioned(
            left: position.x,
            top: position.y,
            child: Container(
              width: widget.dotSize,
              height: widget.dotSize,
              decoration: BoxDecoration(
                color: widget.dotColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

