import 'package:flutter/material.dart';
import 'letter_sufftle_screen.dart';

class ResultScreen extends StatelessWidget {
  final List<QuizResult> results;

  const ResultScreen({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    int correctCount = results.where((r) => r.isCorrect).length;

    return Scaffold(
      appBar: AppBar(title: const Text("Results")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Your Score: $correctCount / ${results.length}",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final result = results[index];
                  return Card(
                    child: ListTile(
                      title: Text(result.word,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      trailing: result.isCorrect
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.cancel, color: Colors.red),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const QuizScreen()),
                );
              },
              child: const Text("Play Again"),
            ),
          ],
        ),
      ),
    );
  }
}
