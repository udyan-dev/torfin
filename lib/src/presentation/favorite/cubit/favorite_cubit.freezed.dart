// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FavoriteState {

  FavoriteStatus get status;

  EmptyState get emptyState;

  List<TorrentRes> get torrents;

  List<TorrentRes> get all;

  String get query;

  bool get isShimmer;

  Set<String> get favoriteKeys;

  AppNotification? get notification;

  String? get fetchingMagnetForKey;
/// Create a copy of FavoriteState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteStateCopyWith<FavoriteState> get copyWith => _$FavoriteStateCopyWithImpl<FavoriteState>(this as FavoriteState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) ||
      (other.runtimeType == runtimeType && other is FavoriteState &&
          (identical(other.status, status) || other.status == status) &&
          (identical(other.emptyState, emptyState) ||
              other.emptyState == emptyState) &&
          const DeepCollectionEquality().equals(other.torrents, torrents) &&
          const DeepCollectionEquality().equals(other.all, all) &&
          (identical(other.query, query) || other.query == query) &&
          (identical(other.isShimmer, isShimmer) ||
              other.isShimmer == isShimmer) &&
          const DeepCollectionEquality().equals(
              other.favoriteKeys, favoriteKeys) &&
          (identical(other.notification, notification) ||
              other.notification == notification) &&
          (identical(other.fetchingMagnetForKey, fetchingMagnetForKey) ||
              other.fetchingMagnetForKey == fetchingMagnetForKey));
}


@override
int get hashCode =>
    Object.hash(
        runtimeType,
        status,
        emptyState,
        const DeepCollectionEquality().hash(torrents),
        const DeepCollectionEquality().hash(all),
        query,
        isShimmer,
        const DeepCollectionEquality().hash(favoriteKeys),
        notification,
        fetchingMagnetForKey);

@override
String toString() {
  return 'FavoriteState(status: $status, emptyState: $emptyState, torrents: $torrents, all: $all, query: $query, isShimmer: $isShimmer, favoriteKeys: $favoriteKeys, notification: $notification, fetchingMagnetForKey: $fetchingMagnetForKey)';
}


}

/// @nodoc
abstract mixin class $FavoriteStateCopyWith<$Res>  {
  factory $FavoriteStateCopyWith(FavoriteState value, $Res Function(FavoriteState) _then) = _$FavoriteStateCopyWithImpl;
@useResult
$Res call({
  FavoriteStatus status, EmptyState emptyState, List<TorrentRes> torrents, List<
      TorrentRes> all, String query, bool isShimmer, Set<
      String> favoriteKeys, AppNotification? notification, String? fetchingMagnetForKey
});


$EmptyStateCopyWith<$Res> get emptyState;

}
/// @nodoc
class _$FavoriteStateCopyWithImpl<$Res>
    implements $FavoriteStateCopyWith<$Res> {
  _$FavoriteStateCopyWithImpl(this._self, this._then);

  final FavoriteState _self;
  final $Res Function(FavoriteState) _then;

/// Create a copy of FavoriteState
/// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call(
      {Object? status = null, Object? emptyState = null, Object? torrents = null, Object? all = null, Object? query = null, Object? isShimmer = null, Object? favoriteKeys = null, Object? notification = freezed, Object? fetchingMagnetForKey = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FavoriteStatus,emptyState: null == emptyState ? _self.emptyState : emptyState // ignore: cast_nullable_to_non_nullable
as EmptyState,torrents: null == torrents ? _self.torrents : torrents // ignore: cast_nullable_to_non_nullable
as List<TorrentRes>,all: null == all ? _self.all : all // ignore: cast_nullable_to_non_nullable
as List<TorrentRes>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isShimmer: null == isShimmer ? _self.isShimmer : isShimmer // ignore: cast_nullable_to_non_nullable
as bool,favoriteKeys: null == favoriteKeys ? _self.favoriteKeys : favoriteKeys // ignore: cast_nullable_to_non_nullable
as Set<String>,notification: freezed == notification ? _self.notification : notification // ignore: cast_nullable_to_non_nullable
  as AppNotification?,
    fetchingMagnetForKey: freezed == fetchingMagnetForKey
        ? _self.fetchingMagnetForKey
        : fetchingMagnetForKey // ignore: cast_nullable_to_non_nullable
    as String?,
  ));
}
/// Create a copy of FavoriteState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmptyStateCopyWith<$Res> get emptyState {
  
  return $EmptyStateCopyWith<$Res>(_self.emptyState, (value) {
    return _then(_self.copyWith(emptyState: value));
  });
}
}


/// Adds pattern-matching-related methods to [FavoriteState].
extension FavoriteStatePatterns on FavoriteState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavoriteState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavoriteState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavoriteState value)  $default,){
final _that = this;
switch (_that) {
case _FavoriteState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavoriteState value)?  $default,){
final _that = this;
switch (_that) {
case _FavoriteState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FavoriteStatus status, EmptyState emptyState, List<TorrentRes> torrents, List<TorrentRes> all, String query, bool isShimmer, Set<String> favoriteKeys, AppNotification? notification, String? fetchingMagnetForKey)? $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavoriteState() when $default != null:
return $default(_that.status,_that.emptyState,_that.torrents,_that.all,_that.query,_that.isShimmer,_that.favoriteKeys,_that.notification,_that.fetchingMagnetForKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FavoriteStatus status, EmptyState emptyState, List<TorrentRes> torrents, List<TorrentRes> all, String query, bool isShimmer, Set<String> favoriteKeys, AppNotification? notification, String? fetchingMagnetForKey) $default,) {final _that = this;
switch (_that) {
case _FavoriteState():
return $default(_that.status,_that.emptyState,_that.torrents,_that.all,_that.query,_that.isShimmer,_that.favoriteKeys,_that.notification,_that.fetchingMagnetForKey);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FavoriteStatus status, EmptyState emptyState, List<TorrentRes> torrents, List<TorrentRes> all, String query, bool isShimmer, Set<String> favoriteKeys, AppNotification? notification, String? fetchingMagnetForKey)? $default,) {final _that = this;
switch (_that) {
case _FavoriteState() when $default != null:
return $default(_that.status,_that.emptyState,_that.torrents,_that.all,_that.query,_that.isShimmer,_that.favoriteKeys,_that.notification,_that.fetchingMagnetForKey);case _:
  return null;

}
}

}

/// @nodoc


class _FavoriteState implements FavoriteState {
  const _FavoriteState({this.status = FavoriteStatus
      .initial, this.emptyState = const EmptyState(), final List<
      TorrentRes> torrents = const <TorrentRes>[], final List<
      TorrentRes> all = const <TorrentRes>[
  ], this.query = '', this.isShimmer = false, final Set<
      String> favoriteKeys = const <String>{
  }, this.notification, this.fetchingMagnetForKey})
      : _torrents = torrents,
        _all = all,
        _favoriteKeys = favoriteKeys;
  

@override@JsonKey() final  FavoriteStatus status;
@override@JsonKey() final  EmptyState emptyState;
 final  List<TorrentRes> _torrents;
@override@JsonKey() List<TorrentRes> get torrents {
  if (_torrents is EqualUnmodifiableListView) return _torrents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_torrents);
}

 final  List<TorrentRes> _all;
@override@JsonKey() List<TorrentRes> get all {
  if (_all is EqualUnmodifiableListView) return _all;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_all);
}

@override@JsonKey() final  String query;
@override@JsonKey() final  bool isShimmer;
 final  Set<String> _favoriteKeys;
@override@JsonKey() Set<String> get favoriteKeys {
  if (_favoriteKeys is EqualUnmodifiableSetView) return _favoriteKeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_favoriteKeys);
}

@override final  AppNotification? notification;
  @override final String? fetchingMagnetForKey;

/// Create a copy of FavoriteState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoriteStateCopyWith<_FavoriteState> get copyWith => __$FavoriteStateCopyWithImpl<_FavoriteState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) ||
      (other.runtimeType == runtimeType && other is _FavoriteState &&
          (identical(other.status, status) || other.status == status) &&
          (identical(other.emptyState, emptyState) ||
              other.emptyState == emptyState) &&
          const DeepCollectionEquality().equals(other._torrents, _torrents) &&
          const DeepCollectionEquality().equals(other._all, _all) &&
          (identical(other.query, query) || other.query == query) &&
          (identical(other.isShimmer, isShimmer) ||
              other.isShimmer == isShimmer) &&
          const DeepCollectionEquality().equals(
              other._favoriteKeys, _favoriteKeys) &&
          (identical(other.notification, notification) ||
              other.notification == notification) &&
          (identical(other.fetchingMagnetForKey, fetchingMagnetForKey) ||
              other.fetchingMagnetForKey == fetchingMagnetForKey));
}


@override
int get hashCode =>
    Object.hash(
        runtimeType,
        status,
        emptyState,
        const DeepCollectionEquality().hash(_torrents),
        const DeepCollectionEquality().hash(_all),
        query,
        isShimmer,
        const DeepCollectionEquality().hash(_favoriteKeys),
        notification,
        fetchingMagnetForKey);

@override
String toString() {
  return 'FavoriteState(status: $status, emptyState: $emptyState, torrents: $torrents, all: $all, query: $query, isShimmer: $isShimmer, favoriteKeys: $favoriteKeys, notification: $notification, fetchingMagnetForKey: $fetchingMagnetForKey)';
}


}

/// @nodoc
abstract mixin class _$FavoriteStateCopyWith<$Res> implements $FavoriteStateCopyWith<$Res> {
  factory _$FavoriteStateCopyWith(_FavoriteState value, $Res Function(_FavoriteState) _then) = __$FavoriteStateCopyWithImpl;
@override @useResult
$Res call({
  FavoriteStatus status, EmptyState emptyState, List<TorrentRes> torrents, List<
      TorrentRes> all, String query, bool isShimmer, Set<
      String> favoriteKeys, AppNotification? notification, String? fetchingMagnetForKey
});


@override $EmptyStateCopyWith<$Res> get emptyState;

}
/// @nodoc
class __$FavoriteStateCopyWithImpl<$Res>
    implements _$FavoriteStateCopyWith<$Res> {
  __$FavoriteStateCopyWithImpl(this._self, this._then);

  final _FavoriteState _self;
  final $Res Function(_FavoriteState) _then;

/// Create a copy of FavoriteState
/// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call(
      {Object? status = null, Object? emptyState = null, Object? torrents = null, Object? all = null, Object? query = null, Object? isShimmer = null, Object? favoriteKeys = null, Object? notification = freezed, Object? fetchingMagnetForKey = freezed,}) {
  return _then(_FavoriteState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FavoriteStatus,emptyState: null == emptyState ? _self.emptyState : emptyState // ignore: cast_nullable_to_non_nullable
as EmptyState,torrents: null == torrents ? _self._torrents : torrents // ignore: cast_nullable_to_non_nullable
as List<TorrentRes>,all: null == all ? _self._all : all // ignore: cast_nullable_to_non_nullable
as List<TorrentRes>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isShimmer: null == isShimmer ? _self.isShimmer : isShimmer // ignore: cast_nullable_to_non_nullable
as bool,favoriteKeys: null == favoriteKeys ? _self._favoriteKeys : favoriteKeys // ignore: cast_nullable_to_non_nullable
as Set<String>,notification: freezed == notification ? _self.notification : notification // ignore: cast_nullable_to_non_nullable
  as AppNotification?,
    fetchingMagnetForKey: freezed == fetchingMagnetForKey
        ? _self.fetchingMagnetForKey
        : fetchingMagnetForKey // ignore: cast_nullable_to_non_nullable
    as String?,
  ));
}

/// Create a copy of FavoriteState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmptyStateCopyWith<$Res> get emptyState {
  
  return $EmptyStateCopyWith<$Res>(_self.emptyState, (value) {
    return _then(_self.copyWith(emptyState: value));
  });
}
}

// dart format on
