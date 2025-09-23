import 'package:flutter/material.dart';

class AnswerBox extends StatelessWidget {
  final List<String?> answer; //  allow null values for empty slots

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
      child: Wrap(
        alignment: WrapAlignment.center,
        children: answer
            .map(
              (e) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    e ?? "_", //  show "_" if empty
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      
    );  
  }
}
