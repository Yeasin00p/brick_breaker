import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class Ball extends StatelessWidget {
  final ballX;
  final ballY;
  final bool isGameOver;
  final bool hasGameStarted;
  const Ball(
      {super.key,
      this.ballX,
      this.ballY,
      required this.isGameOver,
      required this.hasGameStarted});

  @override
  Widget build(BuildContext context) {
    return hasGameStarted
        ? Container(
            alignment: Alignment(ballX, ballY),
            child: Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  color:
                      isGameOver ? Colors.deepPurple[400] : Colors.deepPurple,
                  shape: BoxShape.circle),
            ),
          )
        : Container(
            alignment: Alignment(ballX, ballY),
            child: AvatarGlow(
              endRadius: 60.0,
              child: Material(
                elevation: 8,
                shape: const CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.deepPurple[100],
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepPurple,
                    ),
                    width: 15,
                    height: 15,
                  ),
                ),
              ),
            ),
          );
  }
}
