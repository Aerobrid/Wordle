import 'package:flutter/material.dart';
import 'package:flutter_application_wordle_1/app/app_colors.dart';
import 'package:flutter_application_wordle_1/wordle/wordle.dart';

class HardModePanel extends StatelessWidget {
  const HardModePanel({
    Key? key,
    required this.guessCounts,
    this.backgroundColor,
    this.borderColor,
    this.titleColor,
    this.guessLabelColor,
    this.emptyTextColor,
    this.greenColor,
    this.yellowColor,
    this.blackColor,
    this.badgeTextColor,
  }) : super(key: key);

  // List of color counts for each completed guess
  // Each entry is a map with 'green', 'yellow', 'black' counts
  final List<Map<String, int>> guessCounts;
  
  // Configurable colors
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? titleColor;
  final Color? guessLabelColor;
  final Color? emptyTextColor;
  final Color? greenColor;
  final Color? yellowColor;
  final Color? blackColor;
  final Color? badgeTextColor;

  @override
  Widget build(BuildContext context) {
    // Use provided colors or defaults with good contrast
    final bgColor = backgroundColor ?? Colors.white;
    final border = borderColor ?? Colors.grey.shade400;
    final title = titleColor ?? Colors.black87;
    final guessLabel = guessLabelColor ?? Colors.black87;
    // Use guessLabel color for empty text to match other text colors
    final emptyText = emptyTextColor ?? guessLabel;
    final green = greenColor ?? correctColor;
    final yellow = yellowColor ?? inWordColor;
    final black = blackColor ?? notWordColor;
    final badgeText = badgeTextColor ?? Colors.white;
    
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(8),
        color: bgColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tile Counts',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: title,
            ),
          ),
          const SizedBox(height: 8),
          if (guessCounts.isEmpty)
            Text(
              'No guesses yet',
              style: TextStyle(
                fontSize: 11,
                color: emptyText,
              ),
            )
          else
            ...guessCounts.asMap().entries.map((entry) {
              final index = entry.key;
              final counts = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Guess ${index + 1}:',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: guessLabel,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (counts['green'] != null && counts['green']! > 0)
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: _CountBadge(
                              color: green,
                              count: counts['green']!,
                              textColor: badgeText,
                            ),
                          ),
                        if (counts['yellow'] != null && counts['yellow']! > 0)
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: _CountBadge(
                              color: yellow,
                              count: counts['yellow']!,
                              textColor: badgeText,
                            ),
                          ),
                        if (counts['black'] != null && counts['black']! > 0)
                          _CountBadge(
                            color: black,
                            count: counts['black']!,
                            textColor: badgeText,
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({
    Key? key,
    required this.color,
    required this.count,
    required this.textColor,
  }) : super(key: key);

  final Color color;
  final int count;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}

