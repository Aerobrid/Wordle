import 'dart:math';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_wordle_1/app/app_colors.dart';
import 'package:flutter_application_wordle_1/wordle/wordle.dart';
import 'package:flutter_application_wordle_1/wordle/data/word_list.dart';
import 'package:flutter_application_wordle_1/wordle/widgets/hard_mode_panel.dart';

enum GameStatus {playing, submitting, lost, won}

// since game changes over time it is mutable
class WordleScreen extends StatefulWidget {
  const WordleScreen({ Key? key }) : super(key: key);

  @override 
  _WordleScreenState createState() => _WordleScreenState();
}

class _WordleScreenState extends State<WordleScreen> {
  GameStatus _gameStatus = GameStatus.playing;

  // Loaded dictionary for validation
  Set<String>? _validWords;

  final List<Word> _board = List.generate(
    6,
    (_) => Word(letters: List.generate(5, (_) => Letter.empty())),
  );

  final List<List<GlobalKey<FlipCardState>>> _flipCardKeys = List.generate(
    6,
    (_) => List.generate(5, (_) => GlobalKey<FlipCardState>()),
  );

  int _currentWordIndex = 0;

  // nullable Word
  Word? get _currentWord => 
    _currentWordIndex < _board.length ? _board[_currentWordIndex] : null;

  // random word from list as solution
  Word _solution = Word.fromString(
    fiveLetterWords[Random().nextInt(fiveLetterWords.length)].toUpperCase(),
  );
  
  // for letters guessed
  final Set<Letter> _keyboardLetters = {};
  
  // hard mode toggle - keyboard doesn't show colors, only tiles do
  bool _hardMode = false;
  
  // Track color counts for each completed guess in hard mode
  // Each entry is a map with 'green', 'yellow', 'black' counts
  final List<Map<String, int>> _hardModeGuessCounts = [];
  
  // Focus node for keyboard input
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadWordList();
  }
  
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadWordList() async {
    final data = await rootBundle.loadString('assets/words_5.txt');
    final words = data
        .split(RegExp(r'\r?\n'))
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.length == 5 && RegExp(r'^[a-z]+$').hasMatch(e))
        .toSet();
    setState(() => _validWords = words);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        // elevation to 0 -> no shadow
        elevation: 0,
        title: const Text(
          'WORDLE',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text(
                  'Hard Mode',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: _hardMode,
                  onChanged: (value) {
                    setState(() {
                      _hardMode = value;
                      if (_hardMode) {
                        // Clear keyboard colors when enabling hard mode
                        _keyboardLetters.clear();
                        // Don't clear _hardModeGuessCounts - preserve history
                      } else {
                        // Don't clear hard mode counts - preserve history when toggling
                        // Restore keyboard colors from all previous guesses
                        _restoreKeyboardColors();
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: RawKeyboardListener(
        autofocus: true,
        focusNode: _focusNode,
        onKey: (event) {
          // Only handle key down events
          if (event is! RawKeyDownEvent) {
            return;
          }
          
          if (_gameStatus == GameStatus.playing) {
            final keyLabel = event.logicalKey.keyLabel;
            
            // Handle letter keys (A-Z)
            if (keyLabel.length == 1) {
              final key = keyLabel.toUpperCase();
              if (key.length == 1 && key.codeUnitAt(0) >= 65 && key.codeUnitAt(0) <= 90) {
                _onKeyTapped(key);
                return;
              }
            }
            
            // Handle Enter key
            if (keyLabel == 'Enter') {
              _onEnterTapped();
              return;
            }
            
            // Handle Backspace/Delete
            if (keyLabel == 'Backspace' || keyLabel == 'Delete') {
              _onDeleteTapped();
              return;
            }
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final boardColumn = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Board(board: _board, flipCardKeys: _flipCardKeys, hardMode: _hardMode),
                Keyboard(
                  onKeyTapped: _onKeyTapped,
                  onDeleteTapped: _onDeleteTapped,
                  onEnterTapped: _onEnterTapped,
                  letters: _keyboardLetters,
                ),
              ],
            );

            if (!_hardMode) return Center(child: boardColumn);

            // Calculate panel offset dynamically to align with first board row
            // This ensures alignment works in both windowed and fullscreen
            final mediaQuery = MediaQuery.of(context);
            final screenHeight = mediaQuery.size.height;
            final appBarHeight = kToolbarHeight + mediaQuery.padding.top;
            final availableHeight = screenHeight - appBarHeight;
            
            // Board dimensions (exact measurements)
            const tileHeight = 48.0;                                  // 48px is height of board tile
            const boardHeight = 6 * tileHeight;                       // 288px total
            const keyboardHeight = 180.0;                             // 180px total   
            const totalContentHeight = boardHeight + keyboardHeight;  // 468px total
            
            // Calculate where the first board row actually is (centered layout)
            final centerY = availableHeight / 2;
            final contentTop = centerY - (totalContentHeight / 2);
            
            // Panel has 12px top padding, so offset panel to align its content with first row
            final panelOffset = (contentTop - 12.0).clamp(0.0, double.infinity);

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                boardColumn,
                Padding(
                  padding: EdgeInsets.only(top: panelOffset),
                  child: HardModePanel(guessCounts: _hardModeGuessCounts),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onKeyTapped(String val) {
    if (_gameStatus == GameStatus.playing) {
      setState(() => _currentWord?.addLetter(val));
    }
  }

  void _onDeleteTapped() {
    if (_gameStatus == GameStatus.playing) {
      setState(() => _currentWord?.removeLetter());
    }
  }

  Future<void> _onEnterTapped() async {
    // only submit if playing game, all 5 letters filled, and you still have a try
    if (_gameStatus == GameStatus.playing && _currentWord != null && !_currentWord!.letters.contains(Letter.empty())) {
      // guard
      if (_validWords == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Loading word list...'), duration: Duration(seconds: 2)),
        );
        return;
      }
      // check if word submitted is not a validword and give appropriate msg
      final guessedWord = _currentWord!.wordString.toLowerCase();
      if (!_validWords!.contains(guessedWord)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            dismissDirection: DismissDirection.none,
            duration: const Duration(seconds: 2),
            backgroundColor: finalTryColor,
            content: Text(
              'Entry is not a valid word',
              style: const TextStyle(color: Colors.white),
              )
            ),
          );
        return;
      }

      _gameStatus = GameStatus.submitting;
      

      for (var i = 0; i < _currentWord!.letters.length; i++) {
        final currentWordLetter = _currentWord!.letters[i];
        final currentSolutionLetter = _solution.letters[i];

        // our game logic applied to every letter within word in loop
        setState(() {
          if (currentWordLetter == currentSolutionLetter) {
            _currentWord!.letters[i] = 
              currentWordLetter.copyWith(status: LetterStatus.correct);
          } else if (_solution.letters.contains(currentWordLetter)) {
              _currentWord!.letters[i] = 
                currentWordLetter.copyWith(status: LetterStatus.inWord);
          } else {
              _currentWord!.letters[i] = 
                currentWordLetter.copyWith(status: LetterStatus.notInWord);
          }
        });

        // is letter already guessed?
        // In hard mode, don't update keyboard colors - only show tile colors
        if (!_hardMode) {
          final letter = _keyboardLetters.firstWhere(
            (e) => e.val == currentWordLetter.val,
            orElse: () => Letter.empty(),
          );
          if (letter.status != LetterStatus.correct) {
            _keyboardLetters.removeWhere((e) => e.val == currentWordLetter.val);
            _keyboardLetters.add(_currentWord!.letters[i]);
          }
        }

        // trigger the flip animation
        await Future.delayed(
          const Duration(milliseconds: 150),
          () => _flipCardKeys[_currentWordIndex][i].currentState?.toggleCard(),
        );
      }

      // Calculate color counts for hard mode panel (always track, even when hard mode is off)
      int greenCount = 0;
      int yellowCount = 0;
      int blackCount = 0;
      
      for (var letter in _currentWord!.letters) {
        switch (letter.status) {
          case LetterStatus.correct:
            greenCount++;
            break;
          case LetterStatus.inWord:
            yellowCount++;
            break;
          case LetterStatus.notInWord:
            blackCount++;
            break;
          default:
            break;
        }
      }
      
      setState(() {
        _hardModeGuessCounts.add({
          'green': greenCount,
          'yellow': yellowCount,
          'black': blackCount,
        });
      });

      _checkIfWinOrLoss();
    }
  }

  void _checkIfWinOrLoss(){
    if (_currentWord!.wordString == _solution.wordString) {
      _gameStatus = GameStatus.won;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.none,
          duration: const Duration(days: 1),
          backgroundColor: correctColor,
          content: const Text(
            'You won!',
            style: TextStyle(color: Colors.white),
          ),
          action: SnackBarAction(
            label: 'New Game',
            onPressed: _restart,
            textColor: Colors.white,
          ),
        ),
      );
    } else if (_currentWordIndex + 1 >= _board.length) {
      _gameStatus = GameStatus.lost;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.none,
          duration: const Duration(days: 1),
          backgroundColor: finalTryColor,
          content: Text(
            'You lost! Solution: ${_solution.wordString}',
            style: const TextStyle(color: Colors.white),
          ),
          action: SnackBarAction(
            label: 'New Game',
            onPressed: _restart,
            textColor: Colors.white,
          ),
        ),
      );
    } else {
      _gameStatus = GameStatus.playing;
    }
    _currentWordIndex += 1;
  }

  // Restore keyboard colors from all completed guesses
  void _restoreKeyboardColors() {
    _keyboardLetters.clear();
    // Go through all completed guesses and update keyboard colors
    for (int i = 0; i < _currentWordIndex && i < _board.length; i++) {
      final word = _board[i];
      for (var letter in word.letters) {
        if (letter.status != LetterStatus.initial) {
          final existingLetter = _keyboardLetters.firstWhere(
            (e) => e.val == letter.val,
            orElse: () => Letter.empty(),
          );
          // Only update if letter doesn't exist or if new status is better (correct > inWord > notInWord)
          if (existingLetter == Letter.empty()) {
            _keyboardLetters.add(letter);
          } else {
            // Update if new status is better
            if (letter.status == LetterStatus.correct) {
              _keyboardLetters.removeWhere((e) => e.val == letter.val);
              _keyboardLetters.add(letter);
            } else if (letter.status == LetterStatus.inWord && 
                       existingLetter.status == LetterStatus.notInWord) {
              _keyboardLetters.removeWhere((e) => e.val == letter.val);
              _keyboardLetters.add(letter);
            }
          }
        }
      }
    }
  }

  // when wanting to play another game
  void _restart() {
    setState(() {
      _gameStatus = GameStatus.playing;
      _currentWordIndex = 0;
      _board
        ..clear()
        ..addAll(
          List.generate(
            6,
            (_) => Word(letters: List.generate(5, (_) => Letter.empty())),
          ),
        );
      _solution = Word.fromString(
        fiveLetterWords[Random().nextInt(fiveLetterWords.length)].toUpperCase(),
      );
      _flipCardKeys
        ..clear()
        ..addAll(
          List.generate(
            6,
            (_) => List.generate(5, (_) => GlobalKey<FlipCardState>()),
          ),
        );
      _keyboardLetters.clear();
      _hardModeGuessCounts.clear();
      // Hard mode persists across games
    });
  }
}
