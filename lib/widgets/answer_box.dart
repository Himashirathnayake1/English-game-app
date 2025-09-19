import 'package:flutter/material.dart';

class AnswerBox extends StatelessWidget {
  final List<String> answer;

  const AnswerBox({super.key, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 314,
      height: 57,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.81),
        border: Border.all(color: const Color(0xFFDFDFDF), width: 1),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: answer
            .map((e) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    e,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // ✅ only black letters
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
