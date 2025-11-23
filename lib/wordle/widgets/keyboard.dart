import 'package:flutter/material.dart';
import 'package:flutter_application_wordle_1/wordle/wordle.dart';

// our keyboard layout used
const _qwerty = <List<String>>[
  ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
  ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
  ['ENTER', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'DEL'],
];

class Keyboard extends StatelessWidget {
  // const constructor takes optional, default, and required parameters
  const Keyboard({
    super.key,
    required this.onKeyTapped,
    required this.onDeleteTapped,
    required this.onEnterTapped,
    required this.letters,
  });

  // when letter key is tapped
  final void Function(String) onKeyTapped;
  // whenever enter or del button is tapped we want to callback
  // no value passed, that is why it is void
  final VoidCallback onDeleteTapped;
  final VoidCallback onEnterTapped;
  // for coloring keyboard
  final Set<Letter> letters;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _qwerty.map((keyRow) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: keyRow.map((label) {
            if (label == 'DEL') {
              return _KeyboardButton.delete(onTap: onDeleteTapped);
            } else if (label == 'ENTER') {
              return _KeyboardButton.enter(onTap: onEnterTapped);
            }

            final letterKey = letters.firstWhere(
              (e) => e.val == label,
              orElse: () => Letter.empty(),
            );

            return _KeyboardButton(
              onTap: () => onKeyTapped(label),
              letter: label,
              backgroundColor: letterKey != Letter.empty()
                  ? letterKey.backgroundColor
                  : Colors.grey,
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}

class _KeyboardButton extends StatelessWidget {
  const _KeyboardButton({
    super.key,
    this.width = 30,
    required this.onTap,
    required this.backgroundColor,
    required this.letter,
  });

  // factory constructors for delete and enter keys using callback
  factory _KeyboardButton.delete({ required VoidCallback onTap }) =>
      _KeyboardButton(
        width: 56,
        onTap: onTap,
        backgroundColor: Colors.grey,
        letter: 'DEL',
      );

  factory _KeyboardButton.enter({ required VoidCallback onTap }) =>
      _KeyboardButton(
        width: 56,
        onTap: onTap,
        backgroundColor: Colors.grey,
        letter: 'ENTER',
      );

  final double height = 40;
  final double width;
  final VoidCallback onTap;
  final Color backgroundColor;
  final String letter;

  // overriding parent classes build method
  @override
  Widget build(BuildContext context) {
    // button formatting
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 2.0),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: height,
            width: width,
            child: Center(
              // if letter is del show backspace else just letter
              child: letter == 'DEL'
                  ? const Icon(Icons.backspace_outlined, size: 16, color: Colors.white)
                  : Text(
                      letter,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}