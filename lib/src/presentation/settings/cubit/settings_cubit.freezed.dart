// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsState {

 bool get enableSuggestions; bool get nsfw; bool get enableSpeedLimits; String get downloadSpeedLimit; String get uploadSpeedLimit; String get downloadQueueSize; String get peerPort; AppNotification? get notification;
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsStateCopyWith<SettingsState> get copyWith => _$SettingsStateCopyWithImpl<SettingsState>(this as SettingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsState&&(identical(other.enableSuggestions, enableSuggestions) || other.enableSuggestions == enableSuggestions)&&(identical(other.nsfw, nsfw) || other.nsfw == nsfw)&&(identical(other.enableSpeedLimits, enableSpeedLimits) || other.enableSpeedLimits == enableSpeedLimits)&&(identical(other.downloadSpeedLimit, downloadSpeedLimit) || other.downloadSpeedLimit == downloadSpeedLimit)&&(identical(other.uploadSpeedLimit, uploadSpeedLimit) || other.uploadSpeedLimit == uploadSpeedLimit)&&(identical(other.downloadQueueSize, downloadQueueSize) || other.downloadQueueSize == downloadQueueSize)&&(identical(other.peerPort, peerPort) || other.peerPort == peerPort)&&(identical(other.notification, notification) || other.notification == notification));
}


@override
int get hashCode => Object.hash(runtimeType,enableSuggestions,nsfw,enableSpeedLimits,downloadSpeedLimit,uploadSpeedLimit,downloadQueueSize,peerPort,notification);

@override
String toString() {
  return 'SettingsState(enableSuggestions: $enableSuggestions, nsfw: $nsfw, enableSpeedLimits: $enableSpeedLimits, downloadSpeedLimit: $downloadSpeedLimit, uploadSpeedLimit: $uploadSpeedLimit, downloadQueueSize: $downloadQueueSize, peerPort: $peerPort, notification: $notification)';
}


}

/// @nodoc
abstract mixin class $SettingsStateCopyWith<$Res>  {
  factory $SettingsStateCopyWith(SettingsState value, $Res Function(SettingsState) _then) = _$SettingsStateCopyWithImpl;
@useResult
$Res call({
 bool enableSuggestions, bool nsfw, bool enableSpeedLimits, String downloadSpeedLimit, String uploadSpeedLimit, String downloadQueueSize, String peerPort, AppNotification? notification
});




}
/// @nodoc
class _$SettingsStateCopyWithImpl<$Res>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._self, this._then);

  final SettingsState _self;
  final $Res Function(SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enableSuggestions = null,Object? nsfw = null,Object? enableSpeedLimits = null,Object? downloadSpeedLimit = null,Object? uploadSpeedLimit = null,Object? downloadQueueSize = null,Object? peerPort = null,Object? notification = freezed,}) {
  return _then(_self.copyWith(
enableSuggestions: null == enableSuggestions ? _self.enableSuggestions : enableSuggestions // ignore: cast_nullable_to_non_nullable
as bool,nsfw: null == nsfw ? _self.nsfw : nsfw // ignore: cast_nullable_to_non_nullable
as bool,enableSpeedLimits: null == enableSpeedLimits ? _self.enableSpeedLimits : enableSpeedLimits // ignore: cast_nullable_to_non_nullable
as bool,downloadSpeedLimit: null == downloadSpeedLimit ? _self.downloadSpeedLimit : downloadSpeedLimit // ignore: cast_nullable_to_non_nullable
as String,uploadSpeedLimit: null == uploadSpeedLimit ? _self.uploadSpeedLimit : uploadSpeedLimit // ignore: cast_nullable_to_non_nullable
as String,downloadQueueSize: null == downloadQueueSize ? _self.downloadQueueSize : downloadQueueSize // ignore: cast_nullable_to_non_nullable
as String,peerPort: null == peerPort ? _self.peerPort : peerPort // ignore: cast_nullable_to_non_nullable
as String,notification: freezed == notification ? _self.notification : notification // ignore: cast_nullable_to_non_nullable
as AppNotification?,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingsState].
extension SettingsStatePatterns on SettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsState value)  $default,){
final _that = this;
switch (_that) {
case _SettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enableSuggestions,  bool nsfw,  bool enableSpeedLimits,  String downloadSpeedLimit,  String uploadSpeedLimit,  String downloadQueueSize,  String peerPort,  AppNotification? notification)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.enableSuggestions,_that.nsfw,_that.enableSpeedLimits,_that.downloadSpeedLimit,_that.uploadSpeedLimit,_that.downloadQueueSize,_that.peerPort,_that.notification);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enableSuggestions,  bool nsfw,  bool enableSpeedLimits,  String downloadSpeedLimit,  String uploadSpeedLimit,  String downloadQueueSize,  String peerPort,  AppNotification? notification)  $default,) {final _that = this;
switch (_that) {
case _SettingsState():
return $default(_that.enableSuggestions,_that.nsfw,_that.enableSpeedLimits,_that.downloadSpeedLimit,_that.uploadSpeedLimit,_that.downloadQueueSize,_that.peerPort,_that.notification);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enableSuggestions,  bool nsfw,  bool enableSpeedLimits,  String downloadSpeedLimit,  String uploadSpeedLimit,  String downloadQueueSize,  String peerPort,  AppNotification? notification)?  $default,) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.enableSuggestions,_that.nsfw,_that.enableSpeedLimits,_that.downloadSpeedLimit,_that.uploadSpeedLimit,_that.downloadQueueSize,_that.peerPort,_that.notification);case _:
  return null;

}
}

}

/// @nodoc


class _SettingsState implements SettingsState {
  const _SettingsState({this.enableSuggestions = false, this.nsfw = false, this.enableSpeedLimits = false, this.downloadSpeedLimit = '', this.uploadSpeedLimit = '', this.downloadQueueSize = '', this.peerPort = '', this.notification});
  

@override@JsonKey() final  bool enableSuggestions;
@override@JsonKey() final  bool nsfw;
@override@JsonKey() final  bool enableSpeedLimits;
@override@JsonKey() final  String downloadSpeedLimit;
@override@JsonKey() final  String uploadSpeedLimit;
@override@JsonKey() final  String downloadQueueSize;
@override@JsonKey() final  String peerPort;
@override final  AppNotification? notification;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsStateCopyWith<_SettingsState> get copyWith => __$SettingsStateCopyWithImpl<_SettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsState&&(identical(other.enableSuggestions, enableSuggestions) || other.enableSuggestions == enableSuggestions)&&(identical(other.nsfw, nsfw) || other.nsfw == nsfw)&&(identical(other.enableSpeedLimits, enableSpeedLimits) || other.enableSpeedLimits == enableSpeedLimits)&&(identical(other.downloadSpeedLimit, downloadSpeedLimit) || other.downloadSpeedLimit == downloadSpeedLimit)&&(identical(other.uploadSpeedLimit, uploadSpeedLimit) || other.uploadSpeedLimit == uploadSpeedLimit)&&(identical(other.downloadQueueSize, downloadQueueSize) || other.downloadQueueSize == downloadQueueSize)&&(identical(other.peerPort, peerPort) || other.peerPort == peerPort)&&(identical(other.notification, notification) || other.notification == notification));
}


@override
int get hashCode => Object.hash(runtimeType,enableSuggestions,nsfw,enableSpeedLimits,downloadSpeedLimit,uploadSpeedLimit,downloadQueueSize,peerPort,notification);

@override
String toString() {
  return 'SettingsState(enableSuggestions: $enableSuggestions, nsfw: $nsfw, enableSpeedLimits: $enableSpeedLimits, downloadSpeedLimit: $downloadSpeedLimit, uploadSpeedLimit: $uploadSpeedLimit, downloadQueueSize: $downloadQueueSize, peerPort: $peerPort, notification: $notification)';
}


}

/// @nodoc
abstract mixin class _$SettingsStateCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory _$SettingsStateCopyWith(_SettingsState value, $Res Function(_SettingsState) _then) = __$SettingsStateCopyWithImpl;
@override @useResult
$Res call({
 bool enableSuggestions, bool nsfw, bool enableSpeedLimits, String downloadSpeedLimit, String uploadSpeedLimit, String downloadQueueSize, String peerPort, AppNotification? notification
});




}
/// @nodoc
class __$SettingsStateCopyWithImpl<$Res>
    implements _$SettingsStateCopyWith<$Res> {
  __$SettingsStateCopyWithImpl(this._self, this._then);

  final _SettingsState _self;
  final $Res Function(_SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enableSuggestions = null,Object? nsfw = null,Object? enableSpeedLimits = null,Object? downloadSpeedLimit = null,Object? uploadSpeedLimit = null,Object? downloadQueueSize = null,Object? peerPort = null,Object? notification = freezed,}) {
  return _then(_SettingsState(
enableSuggestions: null == enableSuggestions ? _self.enableSuggestions : enableSuggestions // ignore: cast_nullable_to_non_nullable
as bool,nsfw: null == nsfw ? _self.nsfw : nsfw // ignore: cast_nullable_to_non_nullable
as bool,enableSpeedLimits: null == enableSpeedLimits ? _self.enableSpeedLimits : enableSpeedLimits // ignore: cast_nullable_to_non_nullable
as bool,downloadSpeedLimit: null == downloadSpeedLimit ? _self.downloadSpeedLimit : downloadSpeedLimit // ignore: cast_nullable_to_non_nullable
as String,uploadSpeedLimit: null == uploadSpeedLimit ? _self.uploadSpeedLimit : uploadSpeedLimit // ignore: cast_nullable_to_non_nullable
as String,downloadQueueSize: null == downloadQueueSize ? _self.downloadQueueSize : downloadQueueSize // ignore: cast_nullable_to_non_nullable
as String,peerPort: null == peerPort ? _self.peerPort : peerPort // ignore: cast_nullable_to_non_nullable
as String,notification: freezed == notification ? _self.notification : notification // ignore: cast_nullable_to_non_nullable
as AppNotification?,
  ));
}


}

// dart format on
