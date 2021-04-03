import 'package:flutter/material.dart';
import 'quizpage.dart';

class QuizWelcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Text(
                'Multiple Choice Rorschach Test',
                textAlign: TextAlign.center,
              )),
              Expanded(
                  child: Text(
                      'The Rorschach Test is a projective psychological test developed in 1921 by Hermann Rorschach to measure thought disorder for the purpose of identifying mental illness. It was inspired by the observation that schizophrenia patients often interpret the things they see in unusual ways.')),
              Expanded(
                child: Text('Test Instructions '
                    'This test consists of ten images. For each image you will be given some time to memorize it and then on a following page you will have to pick from a list what the best descriptions of that image is. The original instructions call for each image to be projected on a screen for thirty seconds, this test lets you go as fast as you want, however it is recommended that you not go to fast.'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => QuizPage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Color(0xff21C38A),
                  ),
                  width: 150.0,
                  height: 40.0,
                  padding: EdgeInsets.all(5.0),
                  child: Center(
                    child: Text(
                      'Start',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
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
}
