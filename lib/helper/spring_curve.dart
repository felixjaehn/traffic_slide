import "package:flutter/physics.dart";
import "package:flutter/widgets.dart";

/// Use [Sprung] in place of any curve.
///
/// Opinionated curves are [Sprung.underDamped], [Sprung.criticallyDamped], [Sprung.overDamped].
/// This is the most common way to use [Sprung].
///
/// If you wish to fine tune the damping action, use `Sprung()` which defaults to `Sprung(20)` and
/// is the same as [Sprung.criticallyDamped]. Changing the value will fine tune the damping action.
///
/// If you want full control over making custom spring curves, [Sprung.custom] allows you to adjust
/// damping, stiffness, mass, and velocity.
///
/// ```
/// Sprung.custom(
///   damping: 20,
///   stiffness: 180,
///   mass: 1.0,
///   velocity: 0.0,
/// )
/// ```
class Sprung extends Curve {
  /// A Curve that uses the Flutter Physics engine to drive realistic animations.
  ///
  /// Provides a critically damped spring by default, with an easily overrideable damping value.
  ///
  /// See also: [Sprung.custom], [Sprung.underDamped], [Sprung.criticallyDamped], [Sprung.overDamped]
  factory Sprung([double damping = 20]) => Sprung.custom(damping: damping);

  /// Provides an **under damped** spring, which wobbles loosely at the end.
  static final underDamped = Sprung(12);

  /// Provides a **critically damped** spring, which overshoots once very slightly.
  static final criticallyDamped = Sprung(20);

  /// Provides an **over damped** spring, which smoothly glides into place.
  static final overDamped = Sprung(28);

  /// Provides a critically damped spring by default, with an easily overrideable damping, stiffness,
  /// mass, and initial velocity value.
  Sprung.custom({
    double damping = 20,
    double stiffness = 180,
    double mass = 1.0,
    double velocity = 0.0,
  }) : _sim = SpringSimulation(
          SpringDescription(
            damping: damping,
            mass: mass,
            stiffness: stiffness,
          ),
          0.0,
          1.0,
          velocity,
        );

  /// The underlying physics simulation.
  final SpringSimulation _sim;

  /// Returns the position from the simulator and corrects the final output `x(1.0)` for tight tolerances.
  @override
  double transform(double t) => _sim.x(t) + t * (1 - _sim.x(1.0));
}
