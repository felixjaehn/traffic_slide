import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:traffic_slide/app/app.locator.dart';
import 'package:traffic_slide/services/game_service.dart';

import 'board.dart';
import 'car.dart';
import 'police_car.dart';

// Game coordinate system
//
//   ┌──────► x
//   │
//   │
//   ▼
//   y

var board = Board();
var car = Car();
var policeCar = PoliceCar();

class MovingBackgroundGame extends FlameGame with HasCollidables {
  final GameService _gameService = locator<GameService>();
  bool finish = false;
  bool inMainMenu = true;

  double get carPos => car.position.x;
  double get carPosVert => car.position.y;
  double get policeCarPos => isVertical ? policeCar.position.y : policeCar.position.x;
  double carSize = kIsWeb ? 60 : 40;
  bool isVertical = kIsWeb ? false : true;
  bool gameOver = false;
  Vector2 tempSize = Vector2.zero();

  var streets = ParallaxComponent();
  var verticalStreets = ParallaxComponent();

  @override
  void onGameResize(Vector2 canvasSize) {
    bool shouldBeVertical = canvasSize.x < canvasSize.y;
    if (finish && shouldBeVertical != isVertical) {
      if (isVertical) {
        remove(verticalStreets);
        policeCar.position = Vector2(-(policeCar.position.y - tempSize.y), canvasSize.y / 2 - carSize - 2);
      } else {
        remove(streets);
        policeCar.position = Vector2(canvasSize.x / 2 - carSize - 2, canvasSize.y - policeCar.position.x);
      }

      if (shouldBeVertical) {
        add(verticalStreets);
      } else {
        add(streets);
      }

      isVertical = shouldBeVertical;
      car.updateSize(isVertical);
      policeCar.updateSize(isVertical);
    }

    if (finish && canvasSize != tempSize && !_gameService.levelFinished) {
      if (isVertical && tempSize != Vector2.zero()) {
        board.position = Vector2(size.x / 2 - 166, -40);
      } else if (tempSize != Vector2.zero()) {
        board.position = Vector2(size.x + 40, size.y / 2);
      }
      policeCar.speed = 0;
      if (canvasSize.y * 1.7 < canvasSize.x) {
        carSize = 40;
      }
      tempSize = canvasSize;
    }

    super.onGameResize(canvasSize);
  }

  @override
  Future<void> onLoad() async {
    isVertical = (size.x < size.y);

    verticalStreets = await ParallaxComponent.load(
      [
        ParallaxImageData('mobile_streets.webp'),
      ],
      repeat: ImageRepeat.repeatY,
      fill: LayerFill.width,
      baseVelocity: Vector2(0, -300),
    );

    streets = await ParallaxComponent.load(
      [
        ParallaxImageData('street_parallax.webp'),
      ],
      repeat: ImageRepeat.repeatX,
      baseVelocity: Vector2(300, 0),
    );
    //board = Board(position: isVertical ? Vector2(size.x / 2 - 166, -600) : Vector2(size.x + 600, size.y / 2));
    car =
        Car(position: isVertical ? Vector2(size.x / 2 - carSize - 2, size.y - 400) : Vector2(400, size.y / 2 - carSize - 2), isVertical: isVertical);
    policeCar = PoliceCar(
        position: isVertical ? Vector2(size.x / 2 - carSize - 2, size.y + 1000) : Vector2(-1000, size.y / 2 - carSize - 2), isVertical: isVertical);

    if (isVertical) {
      add(verticalStreets);
    } else {
      add(streets);
    }
    add(car);
    add(policeCar);
    add(_gameService);
    finish = true;
    super.onLoad();
  }

  void pauseParallax() {
    if (isVertical) {
      verticalStreets.parallax?.baseVelocity = Vector2.zero();
    } else {
      streets.parallax?.baseVelocity = Vector2.zero();
    }
  }

  void updateCarPos(double newPos) {
    if (isVertical) {
      car.position = Vector2(size.x / 2 - carSize - 2, size.y - newPos);
    } else {
      car.position = Vector2(newPos, size.y / 2 - carSize - 2);
    }
  }

  void startParallax(double? xVelocity) {
    double x = xVelocity ?? 300;
    if (isVertical) {
      verticalStreets.parallax?.baseVelocity = Vector2(0, -x);
    } else {
      streets.parallax?.baseVelocity = Vector2(x, 0);
    }

    policeCar.speed = -20;
  }

  void pause() {
    board.changeSpeed(0);
    policeCar.speed = 0;
    pauseParallax();
  }

  void startPoliceChase() {
    policeCar.speed = 30;
  }

  void manualRestart() async {
    restartGame();
    if (isVertical) {
      if (policeCar.position.y < size.y) {
        policeCar.position.y = size.y;
      }
      if (!_gameService.levelFinished) {
        board.position = Vector2(size.x / 2 - 166, -40);
        car.collided = false;
      }
    } else {
      if (policeCar.position.x > 0) {
        policeCar.position.x = 0;
      }
      if (!_gameService.levelFinished) {
        board.position = Vector2(size.x + 40, size.y / 2);
        car.collided = false;
      }
    }
  }

  void startGame() {
    board = Board(position: isVertical ? Vector2(size.x / 2 - 166, -600) : Vector2(size.x + 600, size.y / 2));
    add(board);
    inMainMenu = false;
  }

  void resetGame() {
    remove(board);
    policeCar.position = isVertical ? Vector2(size.x / 2 - carSize - 2, size.y + 1000) : Vector2(-1000, size.y / 2 - carSize - 2);
    policeCar.speed = 0;
    gameOver = false;
    car.collided = false;
    startParallax(300);
  }

  void backToMainMenu() {
    resetGame();
    inMainMenu = true;
  }

  void restartGame() {
    board.changeSpeed(300);
    startParallax(300);
    policeCar.speed = -20;
  }

  void onGameEnd() {
    if (!gameOver) {
      _gameService.onGameOver();
      gameOver = true;
      pause();
    }
  }

  void boardOutOfView() {
    _gameService.nextLevel();
    car.collided = false;
  }

  @override
  void update(double dt) {
    _gameService.updatePos(board.position.x, board.position.y);
    super.update(dt);
  }

  void playAngryAnimation() {
    _gameService.playAngryAnimation();
  }
}
