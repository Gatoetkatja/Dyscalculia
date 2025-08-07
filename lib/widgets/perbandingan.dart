import 'package:flutter/material.dart';

class DynamicSizeBoxesWidget extends StatelessWidget {
  final int number1;
  final int number2;
  
  const DynamicSizeBoxesWidget({
    Key? key,
    required this.number1,
    required this.number2,
  }) : super(key: key);

  static const double boxSize = 100.0;
  
  static const double largeFontSize = 32.0;  // For smaller numbers
  static const double smallFontSize = 20.0;  // For larger numbers

  double getFontSize(int currentNumber) {
    if (number1 > number2) {
      return currentNumber == number1 ? smallFontSize : largeFontSize;
    } else if (number2 > number1) {
      return currentNumber == number2 ? smallFontSize : largeFontSize;
    } else {
      return largeFontSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Box 1
        Container(
          width: boxSize,
          height: boxSize,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '$number1',
              style: TextStyle(
                fontSize: getFontSize(number1),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        
        // Box 2
        Container(
          width: boxSize,
          height: boxSize,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '$number2',
              style: TextStyle(
                fontSize: getFontSize(number2),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}