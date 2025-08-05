import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget{
  AnswerButton(this.answer, this.isSelected);

  String answer;
  final isSelected;

  @override
  Widget build(BuildContext){
    return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.lightBlue[100] : Colors.white, // Warna latar belakang saat dipilih
            border: Border.all(
              color: isSelected ? Colors.lightBlue : Colors.grey[300]!, // Warna border saat dipilih
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: 
              Expanded(
                child: Text(
                  answer,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.lightBlue : Colors.black87,
                  ),
                ),
              ),
        );
  }
  
}