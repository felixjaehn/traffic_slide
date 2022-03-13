import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'moving_car.freezed.dart';

@freezed
class MovingCar with _$MovingCar {
  const MovingCar._();
  const factory MovingCar({
    /// The direction in which the car is allowed to move
    required Axis direction,

    /// How many squares the car should occupy
    required int length,

    /// The distance from the top, measured in squares
    /// A distance of 2 means, that the car starts in the third square
    required double top,

    ///The distance from the left, measured in squares
    required double left,

    ///What asset should be displayed
    @Default(0) int assetIndex,
  }) = _MovingCar;
}
