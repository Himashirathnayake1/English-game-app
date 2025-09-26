import 'package:flutter/material.dart';

class LetterButton extends StatelessWidget {
  final String letter;
  final bool isWrong;
  final bool isUsed;
  final VoidCallback onTap;

  const LetterButton({
    super.key,
    required this.letter,
    required this.isWrong,
    required this.isUsed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isUsed ? null : onTap, // disable if used
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 53,
        height: 53,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              isUsed
                  ? const Color(0xFFDDDDDD) // grey if used
                  : isWrong
                  ? Colors.red
                  : Colors.black, //  black when available

          borderRadius: BorderRadius.circular(12),
        ),

        child:
            isUsed
                ? null // hide text when used
                : Text(
                  letter,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
      ),
    );
  }
}
