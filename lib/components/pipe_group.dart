import 'dart:async';
import 'dart:math';

import 'package:bird_question_mark/components/pipe.dart';
import 'package:bird_question_mark/game/my_game.dart';
import 'package:bird_question_mark/resource/assets.dart';
import 'package:bird_question_mark/resource/config.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:uuid/uuid.dart';

class PipeGroup extends PositionComponent with HasGameRef<BirdQuestionMarkGame> {
  PipeGroup() : super(priority: 3);

  final _random = Random();
  late Pipe topPipe;
  late Pipe bottomPipe;
  String id = const Uuid().v4();

  @override
  FutureOr<void> onLoad() {
    super.onLoad();

    position.x = gameRef.size.x;
    final heightMinusGround = gameRef.size.y - Config.groundHeight;
    final centerY = game.pipeSpacing + _random.nextDouble() * (heightMinusGround - game.pipeSpacing);
    final topPosition = Vector2(0, -(centerY + game.pipeSpacing / 2));
    final bottomPosition = Vector2(0, heightMinusGround - (centerY - game.pipeSpacing / 2));

    topPipe = Pipe(
      pipePosition: PipePosition.top,
      position: topPosition,
      onDragging: (event) => _handleOnDragUpdate(event),
    );

    bottomPipe = Pipe(
      pipePosition: PipePosition.bottom,
      position: bottomPosition,
      onDragging: (event) => _handleOnDragUpdate(event),
    );

    addAll([topPipe, bottomPipe]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Move Pipe to the left
    position.x -= game.gameSpeed * dt;

    // Remove Pipe if it's off the screen
    if (position.x + Config.pipeWidth < 0) {
      removeFromParent();
    }
    _checkBirdFlyThrough();
  }

  void _checkBirdFlyThrough() {
    if (position.x + Config.pipeWidth <= gameRef.bird.position.x && !gameRef.passedPipeId.contains(id)) {
      gameRef.passedPipeId.add(id);
      FlameAudio.play(Assets.audios.birdPoint, volume: 0.5);
    }
  }

  void _handleOnDragUpdate(DragUpdateEvent event) {
    final pipeGroup = gameRef.pipeGroups.firstWhere((e) => e.id == id);
    final topPipe = pipeGroup.topPipe;
    final bottomPipe = pipeGroup.bottomPipe;

    topPipe.position.y += event.localDelta.y;
    bottomPipe.position.y += event.localDelta.y;
  }
}
