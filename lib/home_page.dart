import 'dart:async';

import 'package:brick_breaker/cover_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //ball veriabels
  double ballX = 0;
  double ballY = 0;
  //game setting
  bool hasGameStarted =false;

  void startGame() {
    hasGameStarted=true;
    Timer.periodic(
      const Duration(milliseconds: 10),
      (timer) {
        setState(
          () {
            ballY -= 0.01;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: startGame,
      child: Scaffold(
        backgroundColor: Colors.deepPurple[100],
        body: Center(
          child: Stack(
            children: [
              //Tap to play
              CoverScreen(hasGameStarted: hasGameStarted),
              //Ball
              Container(
                alignment: Alignment(ballX, ballY),
                child: Container(
                  height: 15,
                  width: 15,
                  decoration: const BoxDecoration(
                      color: Colors.deepPurple, shape: BoxShape.circle),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
