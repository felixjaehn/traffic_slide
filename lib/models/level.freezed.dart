// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'level.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$LevelTearOff {
  const _$LevelTearOff();

  _Level call(
      {required List<MovingCar> cars,
      List<List> cols = const [],
      List<List> rows = const []}) {
    return _Level(
      cars: cars,
      cols: cols,
      rows: rows,
    );
  }
}

/// @nodoc
const $Level = _$LevelTearOff();

/// @nodoc
mixin _$Level {
  List<MovingCar> get cars => throw _privateConstructorUsedError;
  List<List> get cols => throw _privateConstructorUsedError;
  List<List> get rows => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LevelCopyWith<Level> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LevelCopyWith<$Res> {
  factory $LevelCopyWith(Level value, $Res Function(Level) then) =
      _$LevelCopyWithImpl<$Res>;
  $Res call({List<MovingCar> cars, List<List> cols, List<List> rows});
}

/// @nodoc
class _$LevelCopyWithImpl<$Res> implements $LevelCopyWith<$Res> {
  _$LevelCopyWithImpl(this._value, this._then);

  final Level _value;
  // ignore: unused_field
  final $Res Function(Level) _then;

  @override
  $Res call({
    Object? cars = freezed,
    Object? cols = freezed,
    Object? rows = freezed,
  }) {
    return _then(_value.copyWith(
      cars: cars == freezed
          ? _value.cars
          : cars // ignore: cast_nullable_to_non_nullable
              as List<MovingCar>,
      cols: cols == freezed
          ? _value.cols
          : cols // ignore: cast_nullable_to_non_nullable
              as List<List>,
      rows: rows == freezed
          ? _value.rows
          : rows // ignore: cast_nullable_to_non_nullable
              as List<List>,
    ));
  }
}

/// @nodoc
abstract class _$LevelCopyWith<$Res> implements $LevelCopyWith<$Res> {
  factory _$LevelCopyWith(_Level value, $Res Function(_Level) then) =
      __$LevelCopyWithImpl<$Res>;
  @override
  $Res call({List<MovingCar> cars, List<List> cols, List<List> rows});
}

/// @nodoc
class __$LevelCopyWithImpl<$Res> extends _$LevelCopyWithImpl<$Res>
    implements _$LevelCopyWith<$Res> {
  __$LevelCopyWithImpl(_Level _value, $Res Function(_Level) _then)
      : super(_value, (v) => _then(v as _Level));

  @override
  _Level get _value => super._value as _Level;

  @override
  $Res call({
    Object? cars = freezed,
    Object? cols = freezed,
    Object? rows = freezed,
  }) {
    return _then(_Level(
      cars: cars == freezed
          ? _value.cars
          : cars // ignore: cast_nullable_to_non_nullable
              as List<MovingCar>,
      cols: cols == freezed
          ? _value.cols
          : cols // ignore: cast_nullable_to_non_nullable
              as List<List>,
      rows: rows == freezed
          ? _value.rows
          : rows // ignore: cast_nullable_to_non_nullable
              as List<List>,
    ));
  }
}

/// @nodoc

class _$_Level extends _Level {
  const _$_Level(
      {required this.cars, this.cols = const [], this.rows = const []})
      : super._();

  @override
  final List<MovingCar> cars;
  @JsonKey()
  @override
  final List<List> cols;
  @JsonKey()
  @override
  final List<List> rows;

  @override
  String toString() {
    return 'Level(cars: $cars, cols: $cols, rows: $rows)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Level &&
            const DeepCollectionEquality().equals(other.cars, cars) &&
            const DeepCollectionEquality().equals(other.cols, cols) &&
            const DeepCollectionEquality().equals(other.rows, rows));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(cars),
      const DeepCollectionEquality().hash(cols),
      const DeepCollectionEquality().hash(rows));

  @JsonKey(ignore: true)
  @override
  _$LevelCopyWith<_Level> get copyWith =>
      __$LevelCopyWithImpl<_Level>(this, _$identity);
}

abstract class _Level extends Level {
  const factory _Level(
      {required List<MovingCar> cars,
      List<List> cols,
      List<List> rows}) = _$_Level;
  const _Level._() : super._();

  @override
  List<MovingCar> get cars;
  @override
  List<List> get cols;
  @override
  List<List> get rows;
  @override
  @JsonKey(ignore: true)
  _$LevelCopyWith<_Level> get copyWith => throw _privateConstructorUsedError;
}
