// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'empty_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EmptyState {

 String get stateIcon; String get title; String get description; String get buttonText;
/// Create a copy of EmptyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmptyStateCopyWith<EmptyState> get copyWith => _$EmptyStateCopyWithImpl<EmptyState>(this as EmptyState, _$identity);

  /// Serializes this EmptyState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmptyState&&(identical(other.stateIcon, stateIcon) || other.stateIcon == stateIcon)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.buttonText, buttonText) || other.buttonText == buttonText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stateIcon,title,description,buttonText);

@override
String toString() {
  return 'EmptyState(stateIcon: $stateIcon, title: $title, description: $description, buttonText: $buttonText)';
}


}

/// @nodoc
abstract mixin class $EmptyStateCopyWith<$Res>  {
  factory $EmptyStateCopyWith(EmptyState value, $Res Function(EmptyState) _then) = _$EmptyStateCopyWithImpl;
@useResult
$Res call({
 String stateIcon, String title, String description, String buttonText
});




}
/// @nodoc
class _$EmptyStateCopyWithImpl<$Res>
    implements $EmptyStateCopyWith<$Res> {
  _$EmptyStateCopyWithImpl(this._self, this._then);

  final EmptyState _self;
  final $Res Function(EmptyState) _then;

/// Create a copy of EmptyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stateIcon = null,Object? title = null,Object? description = null,Object? buttonText = null,}) {
  return _then(_self.copyWith(
stateIcon: null == stateIcon ? _self.stateIcon : stateIcon // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,buttonText: null == buttonText ? _self.buttonText : buttonText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EmptyState].
extension EmptyStatePatterns on EmptyState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmptyState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmptyState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmptyState value)  $default,){
final _that = this;
switch (_that) {
case _EmptyState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmptyState value)?  $default,){
final _that = this;
switch (_that) {
case _EmptyState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String stateIcon,  String title,  String description,  String buttonText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmptyState() when $default != null:
return $default(_that.stateIcon,_that.title,_that.description,_that.buttonText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String stateIcon,  String title,  String description,  String buttonText)  $default,) {final _that = this;
switch (_that) {
case _EmptyState():
return $default(_that.stateIcon,_that.title,_that.description,_that.buttonText);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String stateIcon,  String title,  String description,  String buttonText)?  $default,) {final _that = this;
switch (_that) {
case _EmptyState() when $default != null:
return $default(_that.stateIcon,_that.title,_that.description,_that.buttonText);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmptyState extends EmptyState {
  const _EmptyState({this.stateIcon = '', this.title = '', this.description = '', this.buttonText = ''}): super._();
  factory _EmptyState.fromJson(Map<String, dynamic> json) => _$EmptyStateFromJson(json);

@override@JsonKey() final  String stateIcon;
@override@JsonKey() final  String title;
@override@JsonKey() final  String description;
@override@JsonKey() final  String buttonText;

/// Create a copy of EmptyState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmptyStateCopyWith<_EmptyState> get copyWith => __$EmptyStateCopyWithImpl<_EmptyState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmptyStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmptyState&&(identical(other.stateIcon, stateIcon) || other.stateIcon == stateIcon)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.buttonText, buttonText) || other.buttonText == buttonText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stateIcon,title,description,buttonText);

@override
String toString() {
  return 'EmptyState(stateIcon: $stateIcon, title: $title, description: $description, buttonText: $buttonText)';
}


}

/// @nodoc
abstract mixin class _$EmptyStateCopyWith<$Res> implements $EmptyStateCopyWith<$Res> {
  factory _$EmptyStateCopyWith(_EmptyState value, $Res Function(_EmptyState) _then) = __$EmptyStateCopyWithImpl;
@override @useResult
$Res call({
 String stateIcon, String title, String description, String buttonText
});




}
/// @nodoc
class __$EmptyStateCopyWithImpl<$Res>
    implements _$EmptyStateCopyWith<$Res> {
  __$EmptyStateCopyWithImpl(this._self, this._then);

  final _EmptyState _self;
  final $Res Function(_EmptyState) _then;

/// Create a copy of EmptyState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stateIcon = null,Object? title = null,Object? description = null,Object? buttonText = null,}) {
  return _then(_EmptyState(
stateIcon: null == stateIcon ? _self.stateIcon : stateIcon // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,buttonText: null == buttonText ? _self.buttonText : buttonText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
