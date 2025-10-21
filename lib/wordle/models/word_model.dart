import 'package:equatable/equatable.dart';
import 'package:flutter_application_wordle_1/wordle/wordle.dart';

class Word extends Equatable {
  // u need a list of letters for a word
  const Word({required this.letters});

  // string -> Word type
  factory Word.fromString(String word) =>
    Word(letters: word.split('').map((e) => Letter(val: e)).toList());

  final List<Letter> letters;

  // string getter (extract val from each element within letters list and join them)
  String get wordString => letters.map((e) => e.val).join();

  // add letter to 1st empty pos
  void addLetter(String val) {
    final currentIndex = letters.indexWhere((e) => e.val.isEmpty);  
    if (currentIndex != -1) {
      letters[currentIndex] = Letter(val: val);
    }
  }

  // remove last non-empty letter
  void removeLetter() {
    final recentLetterIndex = letters.lastIndexWhere((e) => e.val.isNotEmpty);
    if (recentLetterIndex != -1) {
      letters[recentLetterIndex] = Letter.empty();
    }
  }

  // Equatable used for comparing words based on their respective letters list
  @override
  List<Object> get props => [letters];
}