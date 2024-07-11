import 'dart:async';

import 'package:bird_question_mark/components/pipe_group.dart';
import 'package:bird_question_mark/game/my_game.dart';
import 'package:bird_question_mark/resource/assets.dart';
import 'package:bird_question_mark/resource/config.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';

enum PipePosition { top, bottom }

class Pipe extends SpriteComponent with HasGameRef<BirdQuestionMarkGame>, DragCallbacks {
  Pipe({
    required this.pipePosition,
    required this.onDragging,
    required super.position,
  });

  final PipePosition pipePosition;

  final Function(DragUpdateEvent event) onDragging;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    final pipe = Flame.images.fromCache(Assets.images.pipe);
    final pipeRotated = Flame.images.fromCache(Assets.images.pipeRotated);
    height = gameRef.size.y - Config.groundHeight;
    size = Vector2(50, height);
    switch (pipePosition) {
      case PipePosition.top:
        sprite = Sprite(pipeRotated);
        break;
      case PipePosition.bottom:
        sprite = Sprite(pipe);
        break;
    }
    add(RectangleHitbox());
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (parent is PipeGroup) {
      onDragging(event);
    }
  }
}
