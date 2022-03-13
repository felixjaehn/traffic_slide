import 'package:freezed_annotation/freezed_annotation.dart';

import 'moving_car.dart';

part 'level.freezed.dart';

@freezed
class Level with _$Level {
  const Level._();
  const factory Level({
    required List<MovingCar> cars,
    @Default([]) List<List> cols,
    @Default([]) List<List> rows,
  }) = _Level;
}
