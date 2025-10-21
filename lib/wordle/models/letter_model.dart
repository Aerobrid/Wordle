import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_wordle_1/app/app_colors.dart';

enum LetterStatus { initial, notInWord, inWord, correct, notCorrect }

class Letter extends Equatable {
  const Letter({
    required this.val,
    this.status = LetterStatus.initial,
  });

  // factory constructor used for empty letters using prev constructor
  factory Letter.empty() => const Letter(val: '');

  final String val;
  final LetterStatus status;

  // color getter
  Color get backgroundColor {
    switch (status) {
      case LetterStatus.initial:
        return Colors.transparent;
      case LetterStatus.notInWord:
        return notWordColor;
      case LetterStatus.inWord:
        return inWordColor;
      case LetterStatus.correct:
        return correctColor;
      case LetterStatus.notCorrect:
        return finalTryColor;
    }
  }

  // border getter
  Color get borderColor {
    switch (status) {
      case LetterStatus.initial:
        return Colors.grey;
      default:
        return Colors.transparent;
    }
  }

  // for changing status since immutable
  Letter copyWith({
    String? val,
    LetterStatus? status,
  }) {
    return Letter(
      val: val ?? this.val,
      status: status ?? this.status,
    );
  }
  // props getter for equatable parent class
  @override
  List<Object?> get props => [val, status];
}