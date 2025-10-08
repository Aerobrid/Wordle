// import Flutter widgets 
import 'package:flutter/material.dart';
// WordleScreen import tba

// Main app
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordle App made with Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: const WordleScreen(),
    ); 
  }
}