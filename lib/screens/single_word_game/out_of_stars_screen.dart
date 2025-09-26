import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OutOfStarsScreen extends StatelessWidget {
  final VoidCallback onRestore;
  final VoidCallback onRetry;

  const OutOfStarsScreen({
    super.key,
    required this.onRestore,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top section with coin counter
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "0",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 8),
                          SvgPicture.asset(
                                  'assets/icons/coin.svg',
                                  width: 24,
                                  height: 24,
                                ),
                        
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Main title
              Text(
                "OUT OF STARS !",
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 19.2 / 36, // line-height converted to height
                  letterSpacing: -0.24,
                  // Note: "leading-trim: NONE" is not directly applicable in Flutter
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle
              Text(
                "You've exhausted your ninja stars.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 19.2 / 14, // line-height converted to height
                  letterSpacing: -0.24,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),

              const SizedBox(height: 60),

              // Ninja character illustration
              Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ninja stars in background

                    // Ninja character (using available icons as placeholder)
                    Container(
                      width: 169,
                      height: 277,

                      child: SvgPicture.asset('assets/images/Group 18029.svg'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),

              // Oops message
                Text(
                "Oops!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 19.2 / 14, // line-height converted to height
                  letterSpacing: -0.24,
                  color: Colors.white,
                ),
                ),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  "It looks like the coin vault is empty.\nWatch an ad to continue?",
                  textAlign: TextAlign.center,
                   style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 19.2 / 14, // line-height converted to height
                  letterSpacing: -0.24,
                  color: Colors.white,
                ),
                ),
              ),
SizedBox(height: 42),

              // Action buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    // Restore button
                    GestureDetector(
                      onTap: onRestore,
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "RESTORE",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A90E2),
                              ),
                            ),
                            const SizedBox(width: 18),
                            Text(
                              "1",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          SizedBox(width: 8),
                          SvgPicture.asset(
                                  'assets/icons/coin.svg',
                                  width: 24,
                                  height: 24,
                                ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Retry button
                    GestureDetector(
                      onTap: onRetry,
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            "RETRY",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
