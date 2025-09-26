import 'package:flutter/material.dart';
import 'package:learning_app/screens/practice_vocabulary/listening_screen.dart';

class PracticeVocabularyPage extends StatefulWidget {
  @override
  _PracticeVocabularyPageState createState() => _PracticeVocabularyPageState();
}

class _PracticeVocabularyPageState extends State<PracticeVocabularyPage> {
  String selectedType = "";
  double wordCount = 10;

  Widget _buildTypeButton(String title, IconData icon, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedType = title;
          });
          _showBottomModal();
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
              const SizedBox(width: 6),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.blue : Colors.grey,
                ),
              ),
              if (isSelected)
                const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Icon(Icons.check_circle, color: Colors.blue, size: 18),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomModal() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            height: 130,
            width: double.infinity,
            decoration: const BoxDecoration(
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
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToScreen(selectedType);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "LET'S START",
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
              ],
            ),
          ),
    );
  }

  void _navigateToScreen(String type) {
    switch (type) {
      case "Flash Card":
        // Navigate to Flash Card screen
        Navigator.pushNamed(context, '/flash-card');
        break;
      case "Spelling":
        // Navigate to Letter Shuffle screen (closest available)
        Navigator.pushNamed(context, '/letter-shuffle');
        break;
      case "Listening":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListeningQuizScreen()),
        );
        break;
      case "Quiz":
        // You can add quiz screen route when available
        Navigator.pushNamed(context, '/quiz');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          "Practice Vocabulary",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Type",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildTypeButton(
                  "Flash Card",
                  Icons.menu_book,
                  selectedType == "Flash Card",
                ),
                const SizedBox(width: 12),
                _buildTypeButton(
                  "Spelling",
                  Icons.spellcheck,
                  selectedType == "Spelling",
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildTypeButton(
                  "Listening",
                  Icons.hearing,
                  selectedType == "Listening",
                ),
                const SizedBox(width: 12),
                _buildTypeButton("Quiz", Icons.quiz, selectedType == "Quiz"),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Number Of Words",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Slider(
              activeColor: Colors.blue,
              value: wordCount,
              min: 1,
              max: 20,
              divisions: 19,
              label: wordCount.toInt().toString(),
              onChanged: (value) {
                setState(() {
                  wordCount = value;
                });
              },
            ),
            Center(
              child: Text(
                wordCount.toInt().toString().padLeft(2, '0') + " Words",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D1B4C),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
