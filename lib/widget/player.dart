import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  final palyerX;
  final playerWidth;//out of 2
  const Player({super.key, this.palyerX, this.playerWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(palyerX, 0.9),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 10,
          width: MediaQuery.of(context).size.width*playerWidth,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}