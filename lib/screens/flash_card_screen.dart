import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:learning_app/widgets/bottom_button.dart';

class FlashCardScreen extends StatefulWidget {
  @override
  _FlashCardScreenState createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with close button and progress
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.blue),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: 0.5, // update dynamically
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              "Do you know this word?",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 30),

            // Flip card
            Expanded(
              child: Center(
                child: FlipCard(
                  key: cardKey,
                  flipOnTouch: true,
                  front: buildFrontCard(),
                  back: buildBackCard(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Front side
  Widget buildFrontCard() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.80,
          height: MediaQuery.of(context).size.height * 0.50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width * 0.04,
            ),
            border: Border.all(color: const Color(0xFFDFDFDF), width: 1),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/bag.png",
                  width: MediaQuery.of(context).size.width * 0.42,
                  height: MediaQuery.of(context).size.width * 0.42,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),
                Text(
                  "බෑගය",
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 52),
                GestureDetector(
                  onTap: () {
                    cardKey.currentState?.toggleCard();
                  },
                  child: Column(
                    children: [
                      Icon(Icons.flip, size: 25, color: Colors.blue),
                      const SizedBox(height: 10),
                      Text(
                        "Tap to Study Again",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 80),

        // Bottom button
        GradientButton(
          text: "Yes, I know",
          onPressed: () {
            // your action
          },
          gradientColors: [
            Colors.blue,
            const Color.fromARGB(255, 10, 29, 201),
          ], // optional custom gradient
        ),
      ],
    );
  }

  // Back side
  Widget buildBackCard() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.80,
          height: MediaQuery.of(context).size.height * 0.50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width * 0.04,
            ),
            border: Border.all(color: const Color(0xFFDFDFDF), width: 1),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Bag", style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 20),
                Text(
                  "බෑගය",
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 32),
                Icon(Icons.volume_up, size: 111, color: Colors.red),
                  const SizedBox(height: 52),
                GestureDetector(
                  onTap: () {
                    cardKey.currentState?.toggleCard();
                  },
                  child: Column(
                    children: [
                      Icon(Icons.flip, size: 25, color: Colors.red),
                      const SizedBox(height: 10),
                      Text(
                        "Tap to Flip",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 80),

        // Bottom button
        GradientButton(
          text: "Next Word",
          onPressed: () {
            // your action
          },
          gradientColors: [Colors.red, const Color.fromARGB(255, 117, 5, 5)],
        ),
      ],
    );
  }
}
