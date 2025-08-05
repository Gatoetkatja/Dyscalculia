import 'package:discalculia/question_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget{
  HomePage({super.key});

  @override
  Widget build(context){
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Image.asset('assets/images/detektif.png', width: 200,)),
            SizedBox(height: 10,),
            Text('1 dari 20 anak mengalami diskalkulia', textAlign: TextAlign.center,),
            SizedBox(height: 20,),
            Text('Sudahkah Kamu Mengecek Gejala Diskalkulia?', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => QuestionsScreen()));
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(15)
                )
              ),
              child: const Text('Mulai'))
        ],),
      ),
    );
  }
}