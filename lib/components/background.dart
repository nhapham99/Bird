import 'dart:async';

import 'package:bird_question_mark/game/my_game.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import '../resource/assets.dart';

class Background extends SpriteComponent with HasGameRef<BirdQuestionMarkGame> {
  Background() : super(priority: 1);

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    final background = Flame.images.fromCache(Assets.images.background);
    size = gameRef.size;
    sprite = Sprite(background);
  }
}
