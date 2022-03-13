// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:traffic_slide/models/level.dart';

import '../models/moving_car.dart';

class LevelService with ReactiveServiceMixin {
  final ReactiveValue<Level> _level = ReactiveValue<Level>(Level(
    cars: DateTime.now().second % 2 == 0
        ? [
            MovingCar(direction: Axis.horizontal, length: 3, top: 0, left: 2, assetIndex: 2),
            MovingCar(direction: Axis.horizontal, length: 2, top: 3, left: 2, assetIndex: 25),
            MovingCar(direction: Axis.horizontal, length: 3, top: 5, left: 3, assetIndex: 29),
            MovingCar(direction: Axis.horizontal, length: 2, top: 4, left: 4, assetIndex: 12),
            MovingCar(direction: Axis.vertical, length: 2, top: 4, left: 0, assetIndex: 2),
            MovingCar(direction: Axis.vertical, length: 2, top: 4, left: 2, assetIndex: 63),
            MovingCar(direction: Axis.vertical, length: 2, top: 2, left: 4, assetIndex: 58),
            MovingCar(direction: Axis.vertical, length: 3, top: 0, left: 5, assetIndex: 21),
          ]
        : [
            MovingCar(direction: Axis.horizontal, length: 3, top: 0, left: 0),
            MovingCar(direction: Axis.horizontal, length: 2, top: 4, left: 1),
            MovingCar(direction: Axis.vertical, length: 3, top: 0, left: 4),
            MovingCar(direction: Axis.vertical, length: 3, top: 3, left: 3),
            MovingCar(direction: Axis.vertical, length: 2, top: 1, left: 0),
          ],
  ));
  Level get level => _level.value;

  void updateLevel({required List<List> rows, required List<List> cols}) {
    _level.value = level.copyWith(rows: rows, cols: cols);
  }

  void nextLevel() {
    Random random = Random();
    int randomNr = random.nextInt(45);
    Level randomLevel;

    //Gets the car setup for the next level
    if (randomNr < 30) {
      randomLevel = easyLevel[randomNr % easyLevel.length];
    } else if (randomNr < 40) {
      randomLevel = mediumLevel[randomNr % mediumLevel.length];
    } else {
      randomLevel = hardLevel[randomNr % hardLevel.length];
    }
    //Add an integer for adding a random asset to each car
    _level.value = Level(
      cars: randomLevel.cars.map((e) {
        int assetRandom = random.nextInt(5);
        return MovingCar(
          direction: e.direction,
          left: e.left,
          top: e.top,
          length: e.length,
          assetIndex: assetRandom,
        );
      }).toList(),
    );
    notifyListeners();
  }
}

List<Level> easyLevel = [
  //Tested!
  Level(cars: [
    MovingCar(direction: Axis.horizontal, length: 3, top: 0, left: 0),
    MovingCar(direction: Axis.horizontal, length: 2, top: 4, left: 1),
    MovingCar(direction: Axis.vertical, length: 3, top: 0, left: 4),
    MovingCar(direction: Axis.vertical, length: 3, top: 3, left: 3),
    MovingCar(direction: Axis.vertical, length: 2, top: 1, left: 0),
  ]),
  //Tested!
  Level(cars: [
    MovingCar(direction: Axis.horizontal, length: 3, top: 0, left: 1),
    MovingCar(direction: Axis.horizontal, length: 3, top: 3, left: 0),
    MovingCar(direction: Axis.vertical, length: 2, top: 1, left: 1),
    MovingCar(direction: Axis.vertical, length: 2, top: 4, left: 1),
    MovingCar(direction: Axis.vertical, length: 3, top: 3, left: 4),
    MovingCar(direction: Axis.vertical, length: 2, top: 1, left: 5),
    MovingCar(direction: Axis.vertical, length: 2, top: 2, left: 3),
  ]),
  //Tested!
  Level(cars: [
    MovingCar(direction: Axis.horizontal, length: 3, top: 0, left: 1),
    MovingCar(direction: Axis.horizontal, length: 3, top: 5, left: 0),
    MovingCar(direction: Axis.horizontal, length: 2, top: 3, left: 3),
    MovingCar(direction: Axis.vertical, length: 2, top: 2, left: 0),
    MovingCar(direction: Axis.vertical, length: 2, top: 1, left: 2),
    MovingCar(direction: Axis.vertical, length: 2, top: 3, left: 2),
    MovingCar(direction: Axis.vertical, length: 2, top: 1, left: 4),
  ]),
  //Tested
  Level(cars: [
    MovingCar(direction: Axis.horizontal, length: 2, top: 3, left: 4),
    MovingCar(direction: Axis.horizontal, length: 2, top: 5, left: 4),
    MovingCar(direction: Axis.horizontal, length: 3, top: 4, left: 1),
    MovingCar(direction: Axis.vertical, length: 2, top: 0, left: 1),
    MovingCar(direction: Axis.vertical, length: 3, top: 1, left: 3),
    MovingCar(direction: Axis.vertical, length: 3, top: 0, left: 5),
  ]),
  //Tested
  Level(cars: [
    MovingCar(direction: Axis.horizontal, length: 3, top: 5, left: 2),
    MovingCar(direction: Axis.horizontal, length: 2, top: 0, left: 1),
    MovingCar(direction: Axis.vertical, length: 2, top: 4, left: 0),
    MovingCar(direction: Axis.vertical, length: 2, top: 4, left: 1),
    MovingCar(direction: Axis.vertical, length: 2, top: 1, left: 2),
    MovingCar(direction: Axis.vertical, length: 3, top: 0, left: 3),
    MovingCar(direction: Axis.vertical, length: 3, top: 1, left: 5),
  ])
];

List<Level> mediumLevel = [
  Level(cars: [
    MovingCar(direction: Axis.horizontal, length: 3, top: 0, left: 1),
    MovingCar(direction: Axis.horizontal, length: 2, top: 1, left: 1),
    MovingCar(direction: Axis.horizontal, length: 3, top: 3, left: 1),
    MovingCar(direction: Axis.horizontal, length: 2, top: 5, left: 4),
    MovingCar(direction: Axis.vertical, length: 3, top: 0, left: 4),
    MovingCar(direction: Axis.vertical, length: 2, top: 4, left: 3),
    MovingCar(direction: Axis.vertical, length: 2, top: 4, left: 2),
  ]),
  Level(cars: [
    MovingCar(direction: Axis.horizontal, length: 3, top: 0, left: 2),
    MovingCar(direction: Axis.horizontal, length: 2, top: 3, left: 2),
    MovingCar(direction: Axis.horizontal, length: 3, top: 5, left: 3),
    MovingCar(direction: Axis.horizontal, length: 2, top: 4, left: 4),
    MovingCar(direction: Axis.vertical, length: 2, top: 4, left: 0),
    MovingCar(direction: Axis.vertical, length: 2, top: 4, left: 2),
    MovingCar(direction: Axis.vertical, length: 2, top: 2, left: 4),
    MovingCar(direction: Axis.vertical, length: 3, top: 0, left: 5),
  ]),
  Level(cars: [
    MovingCar(direction: Axis.horizontal, length: 2, top: 0, left: 0, assetIndex: 6),
    MovingCar(direction: Axis.horizontal, length: 2, top: 1, left: 0, assetIndex: 15),
    MovingCar(direction: Axis.horizontal, length: 2, top: 0, left: 2, assetIndex: 29),
    MovingCar(direction: Axis.horizontal, length: 2, top: 1, left: 2, assetIndex: 12),
    MovingCar(direction: Axis.horizontal, length: 2, top: 3, left: 4, assetIndex: 35),
    MovingCar(direction: Axis.horizontal, length: 2, top: 4, left: 2, assetIndex: 19),
    MovingCar(direction: Axis.horizontal, length: 2, top: 5, left: 3, assetIndex: 12),
    MovingCar(direction: Axis.vertical, length: 3, top: 0, left: 4, assetIndex: 2),
    MovingCar(direction: Axis.vertical, length: 2, top: 2, left: 2, assetIndex: 63),
    MovingCar(direction: Axis.vertical, length: 2, top: 2, left: 3, assetIndex: 58),
    MovingCar(direction: Axis.vertical, length: 2, top: 4, left: 0, assetIndex: 11),
    MovingCar(direction: Axis.vertical, length: 2, top: 4, left: 1, assetIndex: 58),
    MovingCar(direction: Axis.vertical, length: 2, top: 0, left: 5, assetIndex: 31),
  ]),
  Level(cars: [
    MovingCar(direction: Axis.horizontal, length: 3, top: 0, left: 1, assetIndex: 6),
    MovingCar(direction: Axis.horizontal, length: 2, top: 1, left: 0, assetIndex: 15),
    MovingCar(direction: Axis.horizontal, length: 3, top: 3, left: 1, assetIndex: 29),
    MovingCar(direction: Axis.horizontal, length: 3, top: 4, left: 3, assetIndex: 12),
    MovingCar(direction: Axis.vertical, length: 2, top: 1, left: 3, assetIndex: 2),
    MovingCar(direction: Axis.vertical, length: 3, top: 1, left: 4, assetIndex: 63),
    MovingCar(direction: Axis.vertical, length: 2, top: 4, left: 2, assetIndex: 58),
  ])
];

List<Level> hardLevel = [
  Level(cars: [
    MovingCar(direction: Axis.horizontal, length: 2, top: 0, left: 0),
    MovingCar(direction: Axis.horizontal, length: 2, top: 0, left: 3),
    MovingCar(direction: Axis.horizontal, length: 3, top: 1, left: 1),
    MovingCar(direction: Axis.horizontal, length: 3, top: 3, left: 0),
    MovingCar(direction: Axis.horizontal, length: 2, top: 5, left: 0),
    MovingCar(direction: Axis.horizontal, length: 2, top: 4, left: 4),
    MovingCar(direction: Axis.vertical, length: 2, top: 4, left: 2),
    MovingCar(direction: Axis.vertical, length: 2, top: 2, left: 3),
    MovingCar(direction: Axis.vertical, length: 3, top: 1, left: 4),
    MovingCar(direction: Axis.vertical, length: 3, top: 1, left: 5),
  ]),
  Level(cars: [
    MovingCar(direction: Axis.horizontal, length: 2, top: 0, left: 2, assetIndex: 6),
    MovingCar(direction: Axis.horizontal, length: 2, top: 3, left: 4, assetIndex: 15),
    MovingCar(direction: Axis.horizontal, length: 2, top: 4, left: 4, assetIndex: 29),
    MovingCar(direction: Axis.horizontal, length: 2, top: 5, left: 4, assetIndex: 29),
    MovingCar(direction: Axis.vertical, length: 2, top: 3, left: 0, assetIndex: 2),
    MovingCar(direction: Axis.vertical, length: 2, top: 2, left: 2, assetIndex: 63),
    MovingCar(direction: Axis.vertical, length: 2, top: 4, left: 2, assetIndex: 58),
    MovingCar(direction: Axis.vertical, length: 3, top: 0, left: 4, assetIndex: 63),
    MovingCar(direction: Axis.vertical, length: 3, top: 0, left: 5, assetIndex: 58),
  ])
];
