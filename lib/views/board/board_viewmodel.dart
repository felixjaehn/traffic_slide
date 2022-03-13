import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:traffic_slide/app/app.locator.dart';
import 'package:traffic_slide/helper/spring_curve.dart';
import 'package:traffic_slide/models/moving_car.dart';
import 'package:traffic_slide/services/game_service.dart';
import 'package:traffic_slide/services/level_service.dart';

class BoardViewModel extends ReactiveViewModel {
  final GameService _gameService = locator<GameService>();
  final LevelService _levelService = locator<LevelService>();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_levelService];

  double divisor = 1 / (3 - 1);
  double _horizontalPos = 1;
  double _verticalPos = 1;

  int boardDimension = 6;

  bool isMoving = false;

  int lowerBound = 0;
  int upperBound = 6;

  //These help to easily get the bounds of the car movement
  List<List> rows = [];
  List<List> cols = [];

  //To animate the cars in place after drag ends
  late List<AnimationController> controller;

  List<MovingCar> get cars => _levelService.level.cars;

  void setUp(TickerProvider vsync) {
    fillRowsAndCols();
    controller = List.generate(cars.length, (i) {
      return AnimationController(duration: const Duration(milliseconds: 400), vsync: vsync);
    });
  }

  void setUpController(TickerProvider vsync) {
    for (AnimationController c in controller) {
      c.dispose();
    }
    controller = List.generate(cars.length, (i) {
      return AnimationController(duration: const Duration(milliseconds: 400), vsync: vsync);
    });
  }

  void fillRowsAndCols() {
    // Fill the Rows and Cols with all zeros
    rows = List.generate(boardDimension, (index) => List.generate(boardDimension, (i) => 0));
    cols = List.generate(boardDimension, (index) => List.generate(boardDimension, (i) => 0));

    //Find where the cars are placed and update the lists accordingly

    for (int i = 0; i < cars.length; i++) {
      for (int j = 0; j < cars[i].length; j++) {
        if (cars[i].direction == Axis.horizontal) {
          if (cars[i].left.round() + j < boardDimension) {
            rows[cars[i].top.round()][cars[i].left.round() + j] = 1;
            cols[cars[i].left.round() + j][cars[i].top.round()] = 1;
          }
        } else {
          if (cars[i].top.round() + j < boardDimension) {
            cols[cars[i].left.round()][cars[i].top.round() + j] = 1;
            rows[cars[i].top.round() + j][cars[i].left.round()] = 1;
          }
        }
      }
    }
    _gameService.updateLevel(cols: cols, rows: rows);
  }

  void moveCar(MovingCar car, DragUpdateDetails details, double renderBoxHeight, double renderBoxWidth, int carIndex, bool isMobileBrowser) {
    double absoluteCarLength = kIsWeb && !isMobileBrowser ? 60 : 40;

    if (car.direction == Axis.horizontal) {
      if (!isMoving) {
        setRowBounds(car.left.round(), car.top.round(), car.length);
        _horizontalPos = car.left;
      }

      double clampStart = lowerBound * 1.0;
      double clampEnd = upperBound - (car.length - 1.0);

      _horizontalPos = (_horizontalPos + (details.delta.dx / (renderBoxWidth - (car.length - 1) * absoluteCarLength))).clamp(clampStart, clampEnd);
      cars[carIndex] = car.copyWith(left: _horizontalPos);
    } else if (car.direction == Axis.vertical) {
      if (!isMoving) {
        setColBounds(car.left.round(), car.top.round(), car.length);
        _verticalPos = car.top;
      }

      double clampStart = lowerBound * 1.0;
      double clampEnd = upperBound - (car.length - 1.0);

      _verticalPos = (_verticalPos + (details.delta.dy / (renderBoxHeight - (car.length - 1) * absoluteCarLength))).clamp(clampStart, clampEnd);
      cars[carIndex] = car.copyWith(top: _verticalPos);
    }
    notifyListeners();
  }

  bool checkForFinnish() {
    int winRow = 2;

    for (int i = 0; i < boardDimension; i++) {
      if (rows[winRow][i] == 1) return false;
    }
    _gameService.incrementScore(1);
    _gameService.restart();
    return true;
  }

  void onDragEnd(DragEndDetails details, MovingCar car, int carIndex) {
    isMoving = false;
    if (car.direction == Axis.horizontal) {
      double start = cars[carIndex].left;
      double end = cars[carIndex].left.roundToDouble();

      final Animation<double> curve = CurvedAnimation(parent: controller[carIndex], curve: Sprung.criticallyDamped);
      Animation<double> getInPlace = Tween<double>(begin: start, end: end).animate(curve);
      controller[carIndex].forward();
      controller[carIndex].addListener(() {
        if (controller[carIndex].isAnimating) {
          cars[carIndex] = car.copyWith(left: getInPlace.value);
          notifyListeners();
        } else if (controller[carIndex].isCompleted) {
          controller[carIndex].reset();
        }
      });
    } else if (car.direction == Axis.vertical) {
      double start = cars[carIndex].top;
      double end = cars[carIndex].top.roundToDouble();
      final Animation<double> curve = CurvedAnimation(parent: controller[carIndex], curve: Sprung.criticallyDamped);
      Animation<double> getInPlace = Tween<double>(begin: start, end: end).animate(curve);
      controller[carIndex].forward();
      controller[carIndex].addListener(() {
        if (controller[carIndex].isAnimating) {
          cars[carIndex] = car.copyWith(top: getInPlace.value);
          notifyListeners();
        } else if (controller[carIndex].isCompleted) {
          controller[carIndex].reset();
        }
      });
    }

    fillRowsAndCols();
    checkForFinnish();
  }

  ///Updates the Row bounds and sets [isMoving] to true
  void setRowBounds(int left, int top, int length) {
    lowerBound = left.floor();
    upperBound = left.floor() + length - 1;
    for (int i = 0; i < boardDimension; i++) {
      //Setting the default states for upper and lower bound
      if (i < left && rows[top][i] == 0 && lowerBound == left) {
        lowerBound = i;
      }
      //Checks the tiles, that are on the right side
      //If there is a car e.g. a value of 1 there is no space to move
      else if (i > left + length - 1 && rows[top][i] == 1) {
        break;
      }
      //If the car has room to the right, the upperBound will be updated
      else if (i > left + length - 1 && rows[top][i] == 0) {
        upperBound = i;
      }
    }
    if (rows[top][max(0, left - 1)] == 1) {
      lowerBound = left;
      isMoving = true;
      return;
    }
    if (rows[top][max(0, left - 2)] == 1 && max(0, left - 2) != 0) {
      lowerBound = left - 1;
      isMoving = true;
      return;
    }

    if (rows[top][max(0, left - 3)] == 1 && max(0, left - 3) != 0) {
      lowerBound = left - 2;
      isMoving = true;
      return;
    }

    isMoving = true;
  }

  ///Updates the Column bounds and sets [isMoving] to true
  void setColBounds(int left, int top, int length) {
    lowerBound = top;
    upperBound = top + length - 1;
    for (int i = 0; i < boardDimension; i++) {
      //Setting the default states for upper and lower bound
      if (i < top && cols[left][i] == 0 && lowerBound == top) {
        lowerBound = i;
      }
      //Checks the tiles, that are on the right side
      //If there is a car e.g. a value of 1 there is no space to move
      else if (i > top + length - 1 && cols[left][i] == 1) {
        break;
      }
      //If the car has room to the right, the upperBound will be updated
      else if (i > top + length - 1 && cols[left][i] == 0) {
        upperBound = i;
      }
    }
    if (cols[left][max(0, top - 1)] == 1) {
      lowerBound = top;
      isMoving = true;
      return;
    }
    if (cols[left][max(0, top - 2)] == 1 && max(0, top - 2) != 0) {
      lowerBound = top - 1;

      isMoving = true;
      return;
    }
    if (cols[left][max(0, top - 3)] == 1 && max(0, top - 3) != 0) {
      lowerBound = top - 2;

      isMoving = true;
      return;
    }
    isMoving = true;
  }

  @override
  void dispose() {
    for (AnimationController c in controller) {
      c.dispose();
    }
    super.dispose();
  }
}
