import 'dart:async';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Map<String, dynamic>> _questions = [
    {
      "question": "What is the capital of France?",
      "options": ["Berlin", "Madrid", "Paris", "Lisbon"],
      "answer": "Paris"
    },
    {
      "question": "Which planet is known as the Red Planet?",
      "options": ["Earth", "Mars", "Jupiter", "Saturn"],
      "answer": "Mars"
    },
    {
      "question": "What is 2 + 2?",
      "options": ["3", "4", "5", "6"],
      "answer": "4"
    }
  ];

  int _currentQuestionIndex = 0;
  int _score = 0;
  int _timer = 10;
  late Timer _questionTimer;
  bool _answered = false;

  void _startTimer() {
    _timer = 10;
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timer > 0) {
        setState(() {
          _timer--;
        });
      } else {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    _questionTimer.cancel();
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _answered = false;
        _startTimer();
      } else {
        _showScore();
      }
    });
  }

  void _checkAnswer(String selectedOption) {
    if (!_answered) {
      _questionTimer.cancel();
      setState(() {
        _answered = true;
        if (selectedOption == _questions[_currentQuestionIndex]['answer']) {
          _score++;
        }
        Future.delayed(const Duration(seconds: 2), _nextQuestion);
      });
    }
  }

  void _showScore() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Quiz Completed"),
        content: Text("Your score: $_score/${_questions.length}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentQuestionIndex = 0;
                _score = 0;
                _answered = false;
                _startTimer();
              });
            },
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _questionTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz App")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Time Left: $_timer s",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 20),
            Text(
              _questions[_currentQuestionIndex]['question'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ..._questions[_currentQuestionIndex]['options'].map<Widget>((option) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ElevatedButton(
                  onPressed: _answered ? null : () => _checkAnswer(option),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: _answered
                        ? (option == _questions[_currentQuestionIndex]['answer']
                            ? Colors.green
                            : Colors.red)
                        : null,
                  ),
                  child: Text(option, style: const TextStyle(fontSize: 18)),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
