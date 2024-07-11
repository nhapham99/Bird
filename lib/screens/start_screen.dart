import 'package:bird_question_mark/game/my_game.dart';
import 'package:bird_question_mark/resource/assets.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key, required this.game});
  static String id = 'start-screen';
  final BirdQuestionMarkGame game;

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play(Assets.audios.background, volume: .25);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FlameAudio.bgm.pause();
        widget.game.overlays.remove(StartScreen.id);
        widget.game.startGame();
      },
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            Assets.images.message,
          ),
        ),
      ),
    );
  }
}
