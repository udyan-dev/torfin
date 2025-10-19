// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coins_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoinsState {

 int get coins;
/// Create a copy of CoinsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoinsStateCopyWith<CoinsState> get copyWith => _$CoinsStateCopyWithImpl<CoinsState>(this as CoinsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoinsState&&(identical(other.coins, coins) || other.coins == coins));
}


@override
int get hashCode => Object.hash(runtimeType,coins);

@override
String toString() {
  return 'CoinsState(coins: $coins)';
}


}

/// @nodoc
abstract mixin class $CoinsStateCopyWith<$Res>  {
  factory $CoinsStateCopyWith(CoinsState value, $Res Function(CoinsState) _then) = _$CoinsStateCopyWithImpl;
@useResult
$Res call({
 int coins
});




}
/// @nodoc
class _$CoinsStateCopyWithImpl<$Res>
    implements $CoinsStateCopyWith<$Res> {
  _$CoinsStateCopyWithImpl(this._self, this._then);

  final CoinsState _self;
  final $Res Function(CoinsState) _then;

/// Create a copy of CoinsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coins = null,}) {
  return _then(_self.copyWith(
coins: null == coins ? _self.coins : coins // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CoinsState].
extension CoinsStatePatterns on CoinsState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoinsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoinsState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoinsState value)  $default,){
final _that = this;
switch (_that) {
case _CoinsState():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoinsState value)?  $default,){
final _that = this;
switch (_that) {
case _CoinsState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int coins)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoinsState() when $default != null:
return $default(_that.coins);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int coins)  $default,) {final _that = this;
switch (_that) {
case _CoinsState():
return $default(_that.coins);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int coins)?  $default,) {final _that = this;
switch (_that) {
case _CoinsState() when $default != null:
return $default(_that.coins);case _:
  return null;

}
}

}

/// @nodoc


class _CoinsState implements CoinsState {
  const _CoinsState({this.coins = initialCoins});
  

@override@JsonKey() final  int coins;

/// Create a copy of CoinsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoinsStateCopyWith<_CoinsState> get copyWith => __$CoinsStateCopyWithImpl<_CoinsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoinsState&&(identical(other.coins, coins) || other.coins == coins));
}


@override
int get hashCode => Object.hash(runtimeType,coins);

@override
String toString() {
  return 'CoinsState(coins: $coins)';
}


}

/// @nodoc
abstract mixin class _$CoinsStateCopyWith<$Res> implements $CoinsStateCopyWith<$Res> {
  factory _$CoinsStateCopyWith(_CoinsState value, $Res Function(_CoinsState) _then) = __$CoinsStateCopyWithImpl;
@override @useResult
$Res call({
 int coins
});




}
/// @nodoc
class __$CoinsStateCopyWithImpl<$Res>
    implements _$CoinsStateCopyWith<$Res> {
  __$CoinsStateCopyWithImpl(this._self, this._then);

  final _CoinsState _self;
  final $Res Function(_CoinsState) _then;

/// Create a copy of CoinsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coins = null,}) {
  return _then(_CoinsState(
coins: null == coins ? _self.coins : coins // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
