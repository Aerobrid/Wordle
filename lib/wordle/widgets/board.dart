import 'package:flutter/material.dart';
import 'package:flutter_application_wordle_1/wordle/wordle.dart';
import 'package:flip_card/flip_card.dart';

class Board extends StatelessWidget {
  const Board({
    Key? key,
    required this.board,
    required this.flipCardKeys,
    this.hardMode = false,
  }) : super(key: key);

  // our 6 tries
  final List<Word> board;
  // 6x5 flip animation keys
  final List<List<GlobalKey<FlipCardState>>> flipCardKeys;
  final bool hardMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: board
          // row (word) loop
          .asMap()
          .map(
            (i, word) =>  MapEntry( 
              i,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: word.letters
                    // col (letters) loop
                    .asMap()
                    .map(
                      (j, letter) => MapEntry(
                        j,
                        // FlipCard is a tile that can flip on back to reveal color
                        FlipCard(
                          // create one for curr pos (tile)
                          key: flipCardKeys[i][j],
                          // user can't flip
                          flipOnTouch: false,
                          direction: FlipDirection.VERTICAL,
                          front: BoardTile(
                            letter: Letter(
                              val: letter.val,
                              status: LetterStatus.initial,
                            ),
                            hardMode: hardMode,
                          ),
                          back: BoardTile(letter: letter, hardMode: hardMode),
                        )
                      ),
                    )
                    // get all 5 flipcards for curr row to display
                    .values
                    // Column() expects a list of vals
                    .toList(),
              ),
            ),
          )
          // get all rows
          .values
          .toList(),
    );
  }
}