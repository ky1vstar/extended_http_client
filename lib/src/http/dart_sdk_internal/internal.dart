part of '../http.dart';

/// A null-check function for function parameters in Null Safety enabled code.
///
/// Because Dart does not have full null safety
/// until all legacy code has been removed from a program,
/// a non-nullable parameter can still end up with a `null` value.
/// This function can be used to guard those functions against null arguments.
/// It throws a [TypeError] because we are really seeing the failure to
/// assign `null` to a non-nullable type.
///
/// See http://dartbug.com/40614 for context.
T checkNotNullable<T extends Object>(T value, String name) {
  if ((value as dynamic) == null) {
    throw NotNullableError<T>(name);
  }
  return value;
}

/// A [TypeError] thrown by [checkNotNullable].
class NotNullableError<T> extends Error implements TypeError {
  final String _name;
  NotNullableError(this._name);
  String toString() => "Null is not a valid value for '$_name' of type '$T'";
}

/// A function that returns the value or default value (if invoked with `null`
/// value) for non-nullable function parameters in Null safety enabled code.
///
/// Because Dart does not have full null safety
/// until all legacy code has been removed from a program,
/// a non-nullable parameter can still end up with a `null` value.
/// This function can be used to get a default value for a parameter
/// when a `null` value is passed in for a non-nullable parameter.
///
/// TODO(40810) - Remove uses of this function when Dart has full null safety.
T valueOfNonNullableParamWithDefault<T extends Object>(T value, T defaultVal) {
  if ((value as dynamic) == null) {
    return defaultVal;
  } else {
    return value;
  }
}