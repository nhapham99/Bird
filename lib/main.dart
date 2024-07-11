import 'package:bird_question_mark/resource/assets.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'game/my_game.dart';
import 'screens/game_over_screen.dart';
import 'screens/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.images.loadAllImages();
  Flame.device.fullScreen();
  Flame.device.setPortrait();
  BirdQuestionMarkGame game = BirdQuestionMarkGame();
  FlameAudio.audioCache.loadAll([
    Assets.audios.background,
    Assets.audios.birdDie,
    Assets.audios.birdHit,
    Assets.audios.birdPoint,
  ]);
  runApp(
    GameWidget(
      game: game,
      initialActiveOverlays: [StartScreen.id],
      overlayBuilderMap: {
        StartScreen.id: (context, _) => StartScreen(game: game),
        GameOverScreen.id: (context, _) => GameOverScreen(game: game),
      },
    ),
  );
}
