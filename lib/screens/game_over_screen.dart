import 'package:bird_question_mark/game/my_game.dart';
import 'package:bird_question_mark/resource/assets.dart';
import 'package:flutter/material.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key, required this.game});

  final BirdQuestionMarkGame game;
  static const String id = 'game-over';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.images.gameOver,
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                game.resetGame();
              },
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Restart',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                    fontFamily: 'Game',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
