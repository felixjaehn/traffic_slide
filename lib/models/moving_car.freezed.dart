// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'moving_car.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$MovingCarTearOff {
  const _$MovingCarTearOff();

  _MovingCar call(
      {required Axis direction,
      required int length,
      required double top,
      required double left,
      int assetIndex = 0}) {
    return _MovingCar(
      direction: direction,
      length: length,
      top: top,
      left: left,
      assetIndex: assetIndex,
    );
  }
}

/// @nodoc
const $MovingCar = _$MovingCarTearOff();

/// @nodoc
mixin _$MovingCar {
  /// The direction in which the car is allowed to move
  Axis get direction => throw _privateConstructorUsedError;

  /// How many squares the car should occupy
  int get length => throw _privateConstructorUsedError;

  /// The distance from the top, measured in squares
  /// A distance of 2 means, that the car starts in the third square
  double get top => throw _privateConstructorUsedError;

  ///The distance from the left, measured in squares
  double get left => throw _privateConstructorUsedError;

  ///What asset should be displayed
  int get assetIndex => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MovingCarCopyWith<MovingCar> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MovingCarCopyWith<$Res> {
  factory $MovingCarCopyWith(MovingCar value, $Res Function(MovingCar) then) =
      _$MovingCarCopyWithImpl<$Res>;
  $Res call(
      {Axis direction, int length, double top, double left, int assetIndex});
}

/// @nodoc
class _$MovingCarCopyWithImpl<$Res> implements $MovingCarCopyWith<$Res> {
  _$MovingCarCopyWithImpl(this._value, this._then);

  final MovingCar _value;
  // ignore: unused_field
  final $Res Function(MovingCar) _then;

  @override
  $Res call({
    Object? direction = freezed,
    Object? length = freezed,
    Object? top = freezed,
    Object? left = freezed,
    Object? assetIndex = freezed,
  }) {
    return _then(_value.copyWith(
      direction: direction == freezed
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as Axis,
      length: length == freezed
          ? _value.length
          : length // ignore: cast_nullable_to_non_nullable
              as int,
      top: top == freezed
          ? _value.top
          : top // ignore: cast_nullable_to_non_nullable
              as double,
      left: left == freezed
          ? _value.left
          : left // ignore: cast_nullable_to_non_nullable
              as double,
      assetIndex: assetIndex == freezed
          ? _value.assetIndex
          : assetIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$MovingCarCopyWith<$Res> implements $MovingCarCopyWith<$Res> {
  factory _$MovingCarCopyWith(
          _MovingCar value, $Res Function(_MovingCar) then) =
      __$MovingCarCopyWithImpl<$Res>;
  @override
  $Res call(
      {Axis direction, int length, double top, double left, int assetIndex});
}

/// @nodoc
class __$MovingCarCopyWithImpl<$Res> extends _$MovingCarCopyWithImpl<$Res>
    implements _$MovingCarCopyWith<$Res> {
  __$MovingCarCopyWithImpl(_MovingCar _value, $Res Function(_MovingCar) _then)
      : super(_value, (v) => _then(v as _MovingCar));

  @override
  _MovingCar get _value => super._value as _MovingCar;

  @override
  $Res call({
    Object? direction = freezed,
    Object? length = freezed,
    Object? top = freezed,
    Object? left = freezed,
    Object? assetIndex = freezed,
  }) {
    return _then(_MovingCar(
      direction: direction == freezed
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as Axis,
      length: length == freezed
          ? _value.length
          : length // ignore: cast_nullable_to_non_nullable
              as int,
      top: top == freezed
          ? _value.top
          : top // ignore: cast_nullable_to_non_nullable
              as double,
      left: left == freezed
          ? _value.left
          : left // ignore: cast_nullable_to_non_nullable
              as double,
      assetIndex: assetIndex == freezed
          ? _value.assetIndex
          : assetIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_MovingCar extends _MovingCar {
  const _$_MovingCar(
      {required this.direction,
      required this.length,
      required this.top,
      required this.left,
      this.assetIndex = 0})
      : super._();

  @override

  /// The direction in which the car is allowed to move
  final Axis direction;
  @override

  /// How many squares the car should occupy
  final int length;
  @override

  /// The distance from the top, measured in squares
  /// A distance of 2 means, that the car starts in the third square
  final double top;
  @override

  ///The distance from the left, measured in squares
  final double left;
  @JsonKey()
  @override

  ///What asset should be displayed
  final int assetIndex;

  @override
  String toString() {
    return 'MovingCar(direction: $direction, length: $length, top: $top, left: $left, assetIndex: $assetIndex)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MovingCar &&
            const DeepCollectionEquality().equals(other.direction, direction) &&
            const DeepCollectionEquality().equals(other.length, length) &&
            const DeepCollectionEquality().equals(other.top, top) &&
            const DeepCollectionEquality().equals(other.left, left) &&
            const DeepCollectionEquality()
                .equals(other.assetIndex, assetIndex));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(direction),
      const DeepCollectionEquality().hash(length),
      const DeepCollectionEquality().hash(top),
      const DeepCollectionEquality().hash(left),
      const DeepCollectionEquality().hash(assetIndex));

  @JsonKey(ignore: true)
  @override
  _$MovingCarCopyWith<_MovingCar> get copyWith =>
      __$MovingCarCopyWithImpl<_MovingCar>(this, _$identity);
}

abstract class _MovingCar extends MovingCar {
  const factory _MovingCar(
      {required Axis direction,
      required int length,
      required double top,
      required double left,
      int assetIndex}) = _$_MovingCar;
  const _MovingCar._() : super._();

  @override

  /// The direction in which the car is allowed to move
  Axis get direction;
  @override

  /// How many squares the car should occupy
  int get length;
  @override

  /// The distance from the top, measured in squares
  /// A distance of 2 means, that the car starts in the third square
  double get top;
  @override

  ///The distance from the left, measured in squares
  double get left;
  @override

  ///What asset should be displayed
  int get assetIndex;
  @override
  @JsonKey(ignore: true)
  _$MovingCarCopyWith<_MovingCar> get copyWith =>
      throw _privateConstructorUsedError;
}
