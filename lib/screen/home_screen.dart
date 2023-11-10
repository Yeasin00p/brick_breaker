import 'dart:async';

import 'package:brick_breaker/widget/ball.dart';
import 'package:brick_breaker/widget/brick.dart';
import 'package:brick_breaker/screen/cover_screen.dart';
import 'package:brick_breaker/screen/game_over_screen.dart';
import 'package:brick_breaker/widget/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum Direction { up, down, left, right }

class _HomePageState extends State<HomePage> {
  //ball veriabels
  double ballX = 0;
  double ballY = 0;
  double ballXIncrement = 0.02;
  double ballYIncrement = 0.01;
  var ballYDriection = Direction.down;
  var ballXDriection = Direction.left;
  //player variabels
  double palyerX = 0;
  double playerWidth = 0.2;
  //brick variables
  static double firstBrickX = -1 * wallGap;
  static double firstBrickY = -0.9;
  static double brickWidth = 0.4;
  static double brickHeight = 0.05;
  static double brickGap = 0.1;
  static int numberOfBrickInRow = 1;
  static double wallGap = 0.5 *
      (2 -
          numberOfBrickInRow * brickWidth -
          (numberOfBrickInRow - 1) * brickGap);

  List myBracks = [
    [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY, false],
  ];
  //game setting
  bool hasGameStarted = false;
  bool isGameOver = false;
  //Start Game
  void startGame() {
    hasGameStarted = true;
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      updateDriection();
      moveBall();
      if (isPlayerDead()) {
        timer.cancel();
        isGameOver = true;
      }
      chackForBrockenBrick();
    });
  }

  void chackForBrockenBrick() {
    for (int i = 0; i < myBracks.length; i++) {
      if (ballX >= myBracks[i][0] &&
          ballX <= myBracks[i][0] + brickWidth &&
          ballY <= myBracks[i][1] + brickHeight &&
          myBracks[i][2] == false) {
        setState(() {
          myBracks[i][2] = true;
          double leftSide = (myBracks[i][0] - ballX).abs();
          double rightSide = (myBracks[i][0] - ballX).abs();
          double topSide = (myBracks[i][i] - ballX).abs();
          double bottomSide = (myBracks[i][i] + brickHeight - ballY).abs();

          String min = findMin(leftSide, rightSide, topSide, bottomSide);
          switch (min) {
            case 'left':
              ballXDriection = Direction.left;
              break;
            case 'right':
              ballXDriection = Direction.right;
              break;
            case 'up':
              ballYDriection = Direction.up;
              break;
            case 'down':
              ballYDriection = Direction.down;
              break;
          }
        });
      }
    }
  }

  String findMin(double a, double b, double c, double d) {
    List<double> myList = [a, b, c, d];
    double curremtMin = a;
    for (int i = 0; i < myList.length; i++) {
      if (myList[i] < curremtMin) {
        curremtMin = myList[i];
      }
    }
    if ((curremtMin - a).abs() < 0.01) {
      return 'left';
    } else if ((curremtMin - b).abs() < 0.01) {
      return 'right';
    } else if ((curremtMin - c).abs() < 0.01) {
      return 'up';
    } else if ((curremtMin - d).abs() < 0.01) {
      return 'down';
    }
    return '';
  }

  bool isPlayerDead() {
    if (ballY >= 1) {
      return true;
    }
    return false;
  }

  //rest game
  void restGame() {
    setState(() {
      palyerX = -0.2;
      ballX = 0;
      ballY = 0;
      isGameOver = false;
      hasGameStarted = false;
      myBracks = [
        [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY, false],
        [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
        [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY, false],
      ];
    });
  }

  //move ball
  void moveBall() {
    setState(() {
      //move horizontal
      if (ballXDriection == Direction.left) {
        ballX -= ballXIncrement;
      } else if (ballXDriection == Direction.right) {
        ballX += ballXIncrement;
      }
      //move vertically
      if (ballYDriection == Direction.down) {
        ballY += ballYIncrement;
      } else if (ballYDriection == Direction.up) {
        ballY -= ballYIncrement;
      }
    });
  }

  void updateDriection() {
    setState(() {
      if (ballY >= 0.9 && ballX >= palyerX && ballX <= palyerX + playerWidth) {
        ballYDriection = Direction.up;
      } else if (ballY <= -1) {
        ballYDriection = Direction.down;
      }
      if (ballX >= 1) {
        ballXDriection = Direction.left;
      } else if (ballX <= -1) {
        ballXDriection = Direction.right;
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
                //game over
                GameOverScreen(
                  isGameOver: isGameOver,
                  function: restGame,
                ),
                //Ball
                Ball(
                  ballX: ballX,
                  ballY: ballY,
                  isGameOver: isGameOver,
                  hasGameStarted: hasGameStarted,
                ),
                //player
                Player(
                  palyerX: palyerX,
                  playerWidth: playerWidth,
                ),
                Brick(
                  brickX: myBracks[0][0],
                  brickY: myBracks[0][1],
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,
                  brickBroken: myBracks[0][2],
                ),
                Brick(
                  brickX: myBracks[1][0],
                  brickY: myBracks[1][1],
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,
                  brickBroken: myBracks[1][2],
                ),
                Brick(
                  brickX: myBracks[2][0],
                  brickY: myBracks[2][1],
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,
                  brickBroken: myBracks[2][2],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
