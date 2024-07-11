import 'dart:async';
import 'dart:math';

import 'package:bird_question_mark/resource/config.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/geometry.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import '../game/my_game.dart';
import '../resource/assets.dart';

enum BirdMovement { idle, die }

class Bird extends SpriteAnimationGroupComponent<BirdMovement> with HasGameRef<BirdQuestionMarkGame>, CollisionCallbacks {
  Bird() : super(priority: 4);

  final double stepTime = 0.05;
  late final SpriteAnimation birdIdle;
  late final SpriteAnimation birdDie;
  double flyTime = 0;
  int flyDistance = 0;
  double oscillationTime = 0;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    birdIdle = SpriteAnimation.fromFrameData(
      gameRef.images.fromCache(Assets.images.bird1),
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: stepTime,
        textureSize: Vector2.all(16),
      ),
    );

    birdDie = SpriteAnimation.fromFrameData(
      gameRef.images.fromCache(Assets.images.bird1),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: stepTime,
        textureSize: Vector2.all(16),
      ),
    );

    animations = {
      BirdMovement.idle: birdIdle,
      BirdMovement.die: birdDie,
    };

    size = Vector2.all(32);
    current = BirdMovement.idle;
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    birdScenario1(dt);
    if (gameRef.isGamePlaying) {
      flyTime += dt;
      flyDistance = (flyTime * gameRef.gameSpeed / 60).round();
    }
  }

  void restart() {
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    flyTime = 0;
    flyDistance = 0;
    oscillationTime = 0;
    current = BirdMovement.idle;
  }

  void birdScenario1(double dt) {
    if (flyDistance >= 500 && game.isGamePlaying) {
      oscillationTime += dt;
      double oscillation = sin(oscillationTime * 2 * pi) * 40;
      position.y = (gameRef.size.y / 2 - size.y / 2) + oscillation;
    }
  }

  void gameOverAnimationUp() {
    add(
      SequenceEffect([
        RotateEffect.by(
          -tau / 6,
          EffectController(duration: 0.1),
        ),
        MoveByEffect(
          Vector2(0, -20),
          EffectController(duration: 0.3, curve: Curves.decelerate),
          onComplete: () => gameOverAnimationDown(),
        ),
      ]),
    );
  }

  void gameOverAnimationDown() {
    FlameAudio.play(Assets.audios.birdDie, volume: 0.5);
    add(
      SequenceEffect([
        RotateEffect.by(
          tau / 4,
          EffectController(duration: 0.3),
        ),
        MoveByEffect(
          Vector2(0, gameRef.size.y - Config.groundHeight),
          EffectController(duration: 1, curve: Curves.decelerate),
          onComplete: () {
            add(RotateEffect.to(tau, EffectController(duration: 0.01)));
            game.showGameOverScreen();
          },
        ),
      ]),
    );
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (gameRef.isGamePlaying) {
      FlameAudio.play(Assets.audios.birdHit, volume: 0.5);
      current = BirdMovement.die;
      game.gameOver();
      gameOverAnimationUp();
    }
  }
}
