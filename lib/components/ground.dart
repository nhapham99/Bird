import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';
import '../game/my_game.dart';
import '../resource/assets.dart';

class Ground extends ParallaxComponent<BirdQuestionMarkGame> with HasGameRef<BirdQuestionMarkGame> {
  Ground() : super(priority: 5);

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    final ground = Flame.images.fromCache(Assets.images.ground);
    parallax = Parallax([
      ParallaxLayer(
        ParallaxImage(ground, fill: LayerFill.none),
      )
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    parallax?.baseVelocity.x = game.gameSpeed;
  }
}
