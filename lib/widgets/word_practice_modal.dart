import 'package:flutter/material.dart';

class WordPracticeModal extends StatefulWidget {
  final Map<String, dynamic> wordData;
  final VoidCallback onPracticePressed;

  const WordPracticeModal({
    super.key,
    required this.wordData,
    required this.onPracticePressed,
  });

  @override
  State<WordPracticeModal> createState() => _WordPracticeModalState();
}

class _WordPracticeModalState extends State<WordPracticeModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue, const Color.fromARGB(255, 10, 29, 201)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 30),

          // Practice button
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 40),
            child: GestureDetector(
              onTap: widget.onPracticePressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "PRACTICE",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
