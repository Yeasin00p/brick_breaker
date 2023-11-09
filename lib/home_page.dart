import 'dart:async';

import 'package:brick_breaker/ball.dart';
import 'package:brick_breaker/cover_screen.dart';
import 'package:brick_breaker/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum direction { UP, DOWN }

class _HomePageState extends State<HomePage> {
  //ball veriabels
  double ballX = 0;
  double ballY = 0;
  var ballDriection = direction.DOWN;
  //player variabels
  double palyerX = 0;
  double playerWidth = 0.3;
  //game setting
  bool hasGameStarted = false;
  //Start Game
  void startGame() {
    hasGameStarted = true;
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      updateDriection();
      moveBall();
    });
  }

  //move ball
  void moveBall() {
    setState(() {
      if (ballDriection == direction.DOWN) {
        ballY += 0.01;
      } else if (ballDriection == direction.UP) {
        ballY -= 0.01;
      }
    });
  }

  void updateDriection() {
    setState(() {
      if (ballY >= 0.9 && ballX >= palyerX && ballX <= palyerX + playerWidth) {
        ballDriection = direction.UP;
      } else if (ballY <= -0.9) {
        ballDriection = direction.DOWN;
      }
    });
  }

  //Move Player Left
  void moveLeft() {
    setState(() {
      if (!(palyerX - 0.2 < -1)) {
        palyerX -= 0.2;
      }
    });
  }

  //Move Player Right
  void moveRight() {
    setState(() {
      if (!(palyerX + playerWidth > 1)) {
        palyerX += 0.2;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (value) {
        if (value.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (value.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
      },
      child: GestureDetector(
        onTap: startGame,
        child: Scaffold(
          backgroundColor: Colors.deepPurple[100],
          body: Center(
            child: Stack(
              children: [
                //Tap to play
                CoverScreen(hasGameStarted: hasGameStarted),
                //Ball
                Ball(
                  ballX: ballX,
                  ballY: ballY,
                ),
                //player
                Player(
                  palyerX: palyerX,
                  playerWidth: playerWidth,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
