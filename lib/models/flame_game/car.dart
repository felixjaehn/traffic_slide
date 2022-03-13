import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/foundation.dart';

import 'game.dart';

class Car extends PositionComponent with HasHitboxes, Collidable, HasGameRef<MovingBackgroundGame> {
  Car({Vector2? position, bool isVertical = false})
      : super(
          position: position,
          size: isVertical
              ? kIsWeb
                  ? Vector2(60, 120)
                  : Vector2(40, 80)
              : Vector2(120, 60),
          anchor: Anchor.topLeft,
        );

  bool collided = false;
  HitboxShape hitbox = HitboxRectangle(relation: Vector2(1, 1));

  @override
  Future<void> onLoad() async {
    addHitbox(hitbox);
    super.onLoad();
  }

  void updateSize(bool isVertical) {
    size = isVertical
        ? kIsWeb
            ? Vector2(60, 120)
            : Vector2(40, 80)
        : Vector2(120, 60);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (!collided) {
      gameRef.playAngryAnimation();
      gameRef.pause();
      gameRef.startPoliceChase();
      collided = true;
    }
  }
}
