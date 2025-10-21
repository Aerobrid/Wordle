// import Flutter widgets necessary for building/running App 
import 'package:flutter/material.dart';
import 'package:flutter_application_wordle_1/wordle/views/wordle_screen.dart';

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