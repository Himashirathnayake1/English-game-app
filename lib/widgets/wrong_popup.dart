import 'package:flutter/material.dart';

class WrongPopup extends StatelessWidget {
  final String word;
  final String translation;
  final VoidCallback onNext;

  const WrongPopup({
    super.key,
    required this.word,
    required this.translation,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 250, 233, 233),
        border: Border.all(color: const Color.fromARGB(255, 217, 39, 39), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 29.0, vertical: 40.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.thumb_down, color: Color.fromARGB(255, 196, 34, 34)),
              const SizedBox(width: 8),
              Text(
                "Wrong!",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text("Wrong Answer", style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 35),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 184, 13, 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onNext,
              child: const Text("Retry", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
