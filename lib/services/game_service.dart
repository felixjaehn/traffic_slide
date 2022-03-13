// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:traffic_slide/models/flame_game/game.dart';
import 'package:traffic_slide/models/level.dart';
import 'package:traffic_slide/models/moving_car.dart';
import 'package:traffic_slide/services/level_service.dart';

import '../app/app.locator.dart';

class GameService extends Component with ReactiveServiceMixin, HasGameRef<MovingBackgroundGame> {
  final LevelService _levelService = locator<LevelService>();
  final ReactiveValue<double> _xPosBoard = ReactiveValue<double>(10000);
  final ReactiveValue<double> _yPosBoard = ReactiveValue<double>(-1000);
  final ReactiveValue<bool> _shouldPlayAnimation = ReactiveValue<bool>(false);

  double get xPosBoard => _xPosBoard.value;
  double get yPosBoard => _yPosBoard.value;
  bool get shouldPlayAnimation => _shouldPlayAnimation.value;
  double get policeCarPos => gameRef.policeCarPos;
  bool get inMainMenu => gameRef.inMainMenu;
  Level get level => _levelService.level;

  int score = 0;
  double baseCarWidth = 120;
  bool playedAnimation = false;
  bool showGameOver = false;
  String animText = "Nice!";
  bool levelFinished = false;

  late AnimationController animController;
  late AnimationController textAnimController;
  late Animation<double> inOpacity;
  late Animation<double> inScale;
  late Animation<double> outOpacity;

  void setUpController(TickerProvider vsync) {
    animController = AnimationController(
      vsync: vsync,
      duration: const Duration(
        seconds: 1,
      ),
    );

    textAnimController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 2),
    );

    inOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: textAnimController,
        curve: const Interval(0, 0.58, curve: Curves.decelerate),
      ),
    );

    inScale = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: textAnimController,
        curve: const Interval(0, 0.58, curve: Curves.decelerate),
      ),
    );

    outOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: textAnimController,
        curve: const Interval(0.81, 1, curve: Curves.easeIn),
      ),
    );
  }

  void updateLevel({required List<List> rows, required List<List> cols}) {
    _levelService.updateLevel(rows: rows, cols: cols);
  }

  void updatePos(double x, double y) {
    _xPosBoard.value = x;
    _yPosBoard.value = y;
    notifyListeners();
  }

  void onGameOver() {
    showGameOver = true;
  }

  void restartGame() {
    gameRef.resetGame();
    gameRef.startGame();

    showGameOver = false;
    score = 0;
    _xPosBoard.value = 10000;
    _yPosBoard.value = -1000;
  }

  void mainMenu() {
    gameRef.backToMainMenu();

    animController.reverse();
    score = 0;
    _xPosBoard.value = 10000;
    _yPosBoard.value = -1000;
    showGameOver = false;
  }

  void updateCarPos(double newPos) {
    gameRef.updateCarPos(newPos);
  }

  void playAngryAnimation() async {
    if (!playedAnimation) {
      _shouldPlayAnimation.value = true;
      await Future.delayed(
        Duration(seconds: 2),
      );
      _shouldPlayAnimation.value = false;
      playedAnimation = true;
    }
  }

  //Gets called as soon as the car gets through one traffic board
  void restart() {
    gameRef.restartGame();
  }

  void nextLevel() {
    levelFinished = false;
    _levelService.nextLevel();
  }

  void dispose() {
    animController.dispose();
  }

  void incrementScore(int increment) async {
    levelFinished = true;
    score += increment;
    int rand = Random().nextInt(4);
    switch (rand) {
      case 0:
        animText = "Nice!";
        break;
      case 1:
        animText = "Great job!";
        break;
      case 2:
        animText = "Immaculate!";
        break;
      case 3:
        animText = "Perfect!";
        break;
      default:
        animText = "Nice!";
        break;
    }
    textAnimController.forward();
    await Future.delayed(
      Duration(seconds: 2),
    );
    textAnimController.reset();
  }

  void manualPause() {
    gameRef.pause();
  }

  void setCarSize(double newSize) {
    gameRef.carSize = newSize;
  }

  void manualRestart() {
    gameRef.manualRestart();
  }

  List<MovingCar> getLevelSetup() {
    return [];
  }
}
