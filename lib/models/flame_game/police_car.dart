import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

import 'game.dart';

class PoliceCar extends PositionComponent with HasGameRef<MovingBackgroundGame> {
  PoliceCar({Vector2? position, bool isVertical = false})
      : super(
          position: position,
          size: isVertical
              ? kIsWeb
                  ? Vector2(60, 120)
                  : Vector2(40, 80)
              : Vector2(120, 60),
          anchor: Anchor.topLeft,
        );

  double speed = 0;

  void updateSize(bool isVertical) {
    size = isVertical
        ? kIsWeb
            ? Vector2(60, 120)
            : Vector2(40, 80)
        : Vector2(120, 60);
  }

  @override
  void update(double dt) {
    if (gameRef.isVertical) {
      position.y -= speed * dt;

      if ((gameRef.carPosVert - position.y).abs() < 2 * gameRef.carSize + 15) {
        gameRef.onGameEnd();

        speed = 0;
      }
    } else {
      position.x += speed * dt;
      if (gameRef.carPos - position.x < 2 * gameRef.carSize + 15) {
        gameRef.onGameEnd();

        speed = 0;
      }
    }
  }
}
