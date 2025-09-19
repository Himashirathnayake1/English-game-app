import 'package:flutter/material.dart';

class CorrectPopup extends StatelessWidget {
  final String word;
  final String translation;
  final VoidCallback onNext;

  const CorrectPopup({
    super.key,
    required this.word,
    required this.translation,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE9FAF0),
        border: Border.all(color: const Color(0xFF27D969), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 29.0, vertical: 40.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.thumb_up, color: Color(0xFF22C45D)),
              const SizedBox(width: 8),
              Text(
                "Correct!",
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text("$word - $translation", style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 35),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onNext,
              child: const Text("Next", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
