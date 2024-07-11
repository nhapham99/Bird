import 'dart:async';
import 'package:bird_question_mark/components/bird.dart';
import 'package:bird_question_mark/components/pipe_group.dart';
import 'package:bird_question_mark/screens/game_over_screen.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import '../components/background.dart';
import '../components/ground.dart';
import '../resource/config.dart';

class BirdQuestionMarkGame extends FlameGame with HasCollisionDetection {
  BirdQuestionMarkGame();
  List<PipeGroup> pipeGroups = [];
  List<String> passedPipeId = [];
  bool _isStartGame = false;
  double gameSpeed = Config.gameSpeed;
  double pipeInterval = Config.pipeInterval;
  double pipeSpacing = Config.pipeSpacing;

  late TextComponent flyDistance;
  late TimerComponent? intervalTimer;
  late Bird bird;

  void startGame() {
    _isStartGame = true;
  }

  bool get isGamePlaying => _isStartGame;

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    addAll([
      Background(),
      intervalTimer = TimerComponent(
        period: Config.pipeInterval,
        repeat: true,
        onTick: () {
          if (_isStartGame) {
            PipeGroup pipeGroup = PipeGroup();
            pipeGroups.add(pipeGroup);
            add(pipeGroup);
          }
        },
      ),
      Ground(),
      bird = Bird(),
      flyDistance = buildFlyDistance(),
    ]);
  }

  TextComponent buildFlyDistance() {
    return TextComponent(
      priority: 6,
      text: 'Distance: 0',
      position: Vector2(size.x / 2, size.y / 2 * 0.2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontFamily: 'Game',
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    intervalTimer?.update(dt);
    flyDistance.text = 'Distance: ${bird.flyDistance}m';
    if (bird.flyDistance % 10 == 0 && bird.flyDistance != 0) {
      _updateSpawnPipeInterval();
      _updateGameSpeed();
      _updatePipeSpacing();
    }
  }

  void _updateSpawnPipeInterval() {
    pipeInterval = (pipeInterval * 0.99).clamp(3, Config.pipeInterval);
    intervalTimer?.timer.limit = pipeInterval;
  }

  void _updateGameSpeed() {
    if (bird.flyDistance < 590) {
      gameSpeed = (gameSpeed + 5).clamp(Config.gameSpeed, Config.gameMaxSpeed);
    } else {
      gameSpeed = Config.gameMaxSpeed - 50.0;
    }
  }

  void _updatePipeSpacing() {
    if (bird.flyDistance < 590) {
      pipeSpacing = (pipeSpacing - 1).clamp(Config.minPipeSpacing, Config.pipeSpacing);
    } else {
      pipeSpacing = Config.pipeSpacing - 50.0;
    }
  }

  void gameOver() {
    gameSpeed = 0.0;
    _isStartGame = false;
  }

  void showGameOverScreen() {
    overlays.add(GameOverScreen.id);
    pauseEngine();
  }

  void resetGame() {
    overlays.remove(GameOverScreen.id);
    _isStartGame = true;
    for (PipeGroup pipeGroup in pipeGroups) {
      pipeGroup.removeFromParent();
    }
    pipeGroups.clear();
    gameSpeed = Config.gameSpeed;
    pipeInterval = Config.pipeInterval;
    pipeSpacing = Config.pipeSpacing;
    bird.restart();
    resumeEngine();
  }

  @override
  void onRemove() {
    FlameAudio.bgm.dispose();
    super.onRemove();
  }
}
