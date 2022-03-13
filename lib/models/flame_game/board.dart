import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/foundation.dart';
import 'package:traffic_slide/models/flame_game/game.dart';

class Board extends PositionComponent with HasHitboxes, Collidable, HasGameRef<MovingBackgroundGame> {
  Board({Vector2? position})
      : super(
          position: position,
          size: Vector2.all(332),
          anchor: Anchor.centerLeft,
        );

  double speed = 300;
  //TODO: May need to be changed
  final double hitBoxFactor = kIsWeb ? 1.25 : 1.1;

  @override
  Future<void> onLoad() async {
    addHitbox(HitboxRectangle(relation: gameRef.isVertical ? Vector2(1, hitBoxFactor) : Vector2(hitBoxFactor, 1)));
    super.onLoad();
  }

  @override
  void update(double dt) {
    if (gameRef.isVertical) {
      position.y += speed * dt;
      if (position.y > gameRef.size.y + 332) {
        gameRef.boardOutOfView();
        position.y = kIsWeb ? -600 : -300;
      }
    } else {
      position.x -= speed * dt;
      if (position.x < -size.x - 100) {
        gameRef.boardOutOfView();
        position.x = gameRef.size.x + 600;
      }
    }
  }

  void changeSpeed(double s) {
    speed = s;
  }
}
