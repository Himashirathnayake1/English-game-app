import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:learning_app/screens/single_word_practice_flow.dart';
import 'package:learning_app/widgets/bottom_button.dart';

class WordPracticeScreen extends StatefulWidget {
  final Map<String, dynamic> wordData;
  final VoidCallback onCompleted;

  const WordPracticeScreen({
    super.key,
    required this.wordData,
    required this.onCompleted,
  });

  @override
  State<WordPracticeScreen> createState() => _WordPracticeScreenState();
}

class _WordPracticeScreenState extends State<WordPracticeScreen> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
  }

  Future<void> _speak(String word) async {
    await flutterTts.speak(word);
  }

  void _startPractice() {
    Navigator.pop(context); // Close modal
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => SingleWordPracticeFlow(
              wordData: widget.wordData,
              onCompleted: widget.onCompleted,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with close button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFF4A90E2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, color: Colors.white, size: 24),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              "Review a word",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3A59),
              ),
            ),

            const SizedBox(height: 60),

            // Word image container
            Container(
              width: screenWidth * 0.80,
              height: screenHeight * 0.50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.04,
                ),
                border: Border.all(color: const Color(0xFFDFDFDF), width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child:
                          widget.wordData['imagePath'].endsWith('.svg')
                              ? SvgPicture.asset(
                                widget.wordData['imagePath'],
                                width: MediaQuery.of(context).size.width * 0.42,
                                height:
                                    MediaQuery.of(context).size.width * 0.42,
                                fit: BoxFit.contain,
                              )
                              : Image.asset(
                                widget.wordData['imagePath'],
                                width: MediaQuery.of(context).size.width * 0.42,
                                height:
                                    MediaQuery.of(context).size.width * 0.42,
                                fit: BoxFit.contain,
                              ),
                    ),
                  ),

                  // Word text
                  Text(
                    widget.wordData['word'],
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(fontSize: 25, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  // Translation
                  Text(
                    widget.wordData['translation'],
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 18),
                  ),

                  const SizedBox(height: 30),

                  // Speaker button
                  GestureDetector(
                    onTap: () => _speak(widget.wordData['word']),

                    child: Icon(
                      Icons.volume_up,
                      color: Color.fromRGBO(65, 61, 102, 1.0),
                      size: 25,
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),

            const SizedBox(height: 45),

            // Let's Start button
            GradientButton(
              text: "Lets's Start",
              onPressed: _startPractice,
              gradientColors: [
                Colors.blue,
                const Color.fromARGB(255, 10, 29, 201),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
}
