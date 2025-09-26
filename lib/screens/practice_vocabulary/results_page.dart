import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:learning_app/widgets/bottom_button.dart';

class ResultsPage extends StatelessWidget {
  final List<Map<String, String>> masteredWords;
  final List<Map<String, String>> toReviewWords;
  final VoidCallback onReviewAgain;
  final VoidCallback onHome;
  final FlutterTts flutterTts = FlutterTts();

  ResultsPage({
    super.key,
    required this.masteredWords,
    required this.toReviewWords,
    required this.onReviewAgain,
    required this.onHome,
  });
  Future<void> _speak(String word) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(word);
  }

  @override
  Widget build(BuildContext context) {
    int total = masteredWords.length + toReviewWords.length;
    double percentage = total > 0 ? (masteredWords.length / total) * 100 : 0;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Linear Gradient Box at the top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: 374.71,
                height: 199.84,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.blue,
                      const Color.fromARGB(255, 10, 29, 201),
                    ],
                  ),
                ),
              ),
            ),
            // Main Content
            Column(
              children: [
                const SizedBox(height: 30),

                // Title
                Text(
                  "Your Vocabulary Level",
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 10),

                // Percentage
                Text(
                  "${percentage.toStringAsFixed(0)}%",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Mastered / To review summary
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  padding: EdgeInsets.all(36),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            "Mastered ${masteredWords.length.toString().padLeft(2, "0")}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.repeat, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            "To review ${toReviewWords.length.toString().padLeft(2, "0")}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // To review list
                if (toReviewWords.isNotEmpty) ...[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Icon(Icons.repeat, color: Colors.blue),
                        Text(
                          "Words to Review Again",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                      itemCount: toReviewWords.length,
                      itemBuilder: (context, index) {
                        final word = toReviewWords[index];
                        return Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          color: Colors.white,
                          child: ListTile(
                            leading: IconButton(
                              icon: Icon(Icons.volume_up, color: Colors.blue),
                              onPressed: () {
                                _speak(word["word"]!); // Speak the English word
                              },
                            ),
                            title: Text(
                              word["word"] ?? "",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              word["translation"] ?? "",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            onTap: () {
                              _speak(word["word"]!);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ] else
                  Expanded(
                    child: Center(
                      child: Text(
                        "Great! No words to review 🎉",
                        style: TextStyle(color: Colors.green, fontSize: 16),
                      ),
                    ),
                  ),

                // Buttons
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      // Review Again Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: Size(294.93, 62.49),
                          side: BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: onReviewAgain,
                        child: Text(
                          "Review Again",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Home Button
                      GradientButton(
                        text: "Home",
                        onPressed: onHome,
                        gradientColors: [
                          Colors.blue,
                          const Color.fromARGB(255, 10, 29, 201),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
