import 'package:flutter/material.dart';
import 'package:flutter_application_wordle_1/wordle/wordle.dart';

class BoardTile extends StatelessWidget {
  const BoardTile({
    Key? key,
    // each tile has a letter
    required this.letter,
    this.hardMode = false,
  }) : super(key: key);

  final Letter letter;
  final bool hardMode;

  @override
  Widget build(BuildContext context) {
    // In hard mode, don't show colors - keep tiles grey/transparent
    final backgroundColor = hardMode && letter.status != LetterStatus.initial
        ? Colors.transparent
        : letter.backgroundColor;
    final borderColor = hardMode && letter.status != LetterStatus.initial
        ? Colors.grey
        : letter.borderColor;
    
    return Container(
      margin: const EdgeInsets.all(4),
      height: 48,
      width: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(4),
        ),
      child: Text(
        letter.val,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}