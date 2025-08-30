// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trending_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrendingState {

 TrendingStatus get status; EmptyState get emptyState; List<TorrentRes> get torrents; List<TorrentRes> get rawTorrentList; SortType get sortType; List<String> get categoriesRaw; String? get selectedCategoryRaw; bool get isShimmer; TrendingType get trendingType; Map<TrendingType, List<TorrentRes>> get cacheByType; Set<String> get favoriteKeys; AppNotification? get notification;
/// Create a copy of TrendingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrendingStateCopyWith<TrendingState> get copyWith => _$TrendingStateCopyWithImpl<TrendingState>(this as TrendingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrendingState&&(identical(other.status, status) || other.status == status)&&(identical(other.emptyState, emptyState) || other.emptyState == emptyState)&&const DeepCollectionEquality().equals(other.torrents, torrents)&&const DeepCollectionEquality().equals(other.rawTorrentList, rawTorrentList)&&(identical(other.sortType, sortType) || other.sortType == sortType)&&const DeepCollectionEquality().equals(other.categoriesRaw, categoriesRaw)&&(identical(other.selectedCategoryRaw, selectedCategoryRaw) || other.selectedCategoryRaw == selectedCategoryRaw)&&(identical(other.isShimmer, isShimmer) || other.isShimmer == isShimmer)&&(identical(other.trendingType, trendingType) || other.trendingType == trendingType)&&const DeepCollectionEquality().equals(other.cacheByType, cacheByType)&&const DeepCollectionEquality().equals(other.favoriteKeys, favoriteKeys)&&(identical(other.notification, notification) || other.notification == notification));
}


@override
int get hashCode => Object.hash(runtimeType,status,emptyState,const DeepCollectionEquality().hash(torrents),const DeepCollectionEquality().hash(rawTorrentList),sortType,const DeepCollectionEquality().hash(categoriesRaw),selectedCategoryRaw,isShimmer,trendingType,const DeepCollectionEquality().hash(cacheByType),const DeepCollectionEquality().hash(favoriteKeys),notification);

@override
String toString() {
  return 'TrendingState(status: $status, emptyState: $emptyState, torrents: $torrents, rawTorrentList: $rawTorrentList, sortType: $sortType, categoriesRaw: $categoriesRaw, selectedCategoryRaw: $selectedCategoryRaw, isShimmer: $isShimmer, trendingType: $trendingType, cacheByType: $cacheByType, favoriteKeys: $favoriteKeys, notification: $notification)';
}


}

/// @nodoc
abstract mixin class $TrendingStateCopyWith<$Res>  {
  factory $TrendingStateCopyWith(TrendingState value, $Res Function(TrendingState) _then) = _$TrendingStateCopyWithImpl;
@useResult
$Res call({
 TrendingStatus status, EmptyState emptyState, List<TorrentRes> torrents, List<TorrentRes> rawTorrentList, SortType sortType, List<String> categoriesRaw, String? selectedCategoryRaw, bool isShimmer, TrendingType trendingType, Map<TrendingType, List<TorrentRes>> cacheByType, Set<String> favoriteKeys, AppNotification? notification
});


$EmptyStateCopyWith<$Res> get emptyState;

}
/// @nodoc
class _$TrendingStateCopyWithImpl<$Res>
    implements $TrendingStateCopyWith<$Res> {
  _$TrendingStateCopyWithImpl(this._self, this._then);

  final TrendingState _self;
  final $Res Function(TrendingState) _then;

/// Create a copy of TrendingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? emptyState = null,Object? torrents = null,Object? rawTorrentList = null,Object? sortType = null,Object? categoriesRaw = null,Object? selectedCategoryRaw = freezed,Object? isShimmer = null,Object? trendingType = null,Object? cacheByType = null,Object? favoriteKeys = null,Object? notification = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TrendingStatus,emptyState: null == emptyState ? _self.emptyState : emptyState // ignore: cast_nullable_to_non_nullable
as EmptyState,torrents: null == torrents ? _self.torrents : torrents // ignore: cast_nullable_to_non_nullable
as List<TorrentRes>,rawTorrentList: null == rawTorrentList ? _self.rawTorrentList : rawTorrentList // ignore: cast_nullable_to_non_nullable
as List<TorrentRes>,sortType: null == sortType ? _self.sortType : sortType // ignore: cast_nullable_to_non_nullable
as SortType,categoriesRaw: null == categoriesRaw ? _self.categoriesRaw : categoriesRaw // ignore: cast_nullable_to_non_nullable
as List<String>,selectedCategoryRaw: freezed == selectedCategoryRaw ? _self.selectedCategoryRaw : selectedCategoryRaw // ignore: cast_nullable_to_non_nullable
as String?,isShimmer: null == isShimmer ? _self.isShimmer : isShimmer // ignore: cast_nullable_to_non_nullable
as bool,trendingType: null == trendingType ? _self.trendingType : trendingType // ignore: cast_nullable_to_non_nullable
as TrendingType,cacheByType: null == cacheByType ? _self.cacheByType : cacheByType // ignore: cast_nullable_to_non_nullable
as Map<TrendingType, List<TorrentRes>>,favoriteKeys: null == favoriteKeys ? _self.favoriteKeys : favoriteKeys // ignore: cast_nullable_to_non_nullable
as Set<String>,notification: freezed == notification ? _self.notification : notification // ignore: cast_nullable_to_non_nullable
as AppNotification?,
  ));
}
/// Create a copy of TrendingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmptyStateCopyWith<$Res> get emptyState {
  
  return $EmptyStateCopyWith<$Res>(_self.emptyState, (value) {
    return _then(_self.copyWith(emptyState: value));
  });
}
}


/// Adds pattern-matching-related methods to [TrendingState].
extension TrendingStatePatterns on TrendingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrendingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrendingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrendingState value)  $default,){
final _that = this;
switch (_that) {
case _TrendingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrendingState value)?  $default,){
final _that = this;
switch (_that) {
case _TrendingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TrendingStatus status,  EmptyState emptyState,  List<TorrentRes> torrents,  List<TorrentRes> rawTorrentList,  SortType sortType,  List<String> categoriesRaw,  String? selectedCategoryRaw,  bool isShimmer,  TrendingType trendingType,  Map<TrendingType, List<TorrentRes>> cacheByType,  Set<String> favoriteKeys,  AppNotification? notification)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrendingState() when $default != null:
return $default(_that.status,_that.emptyState,_that.torrents,_that.rawTorrentList,_that.sortType,_that.categoriesRaw,_that.selectedCategoryRaw,_that.isShimmer,_that.trendingType,_that.cacheByType,_that.favoriteKeys,_that.notification);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TrendingStatus status,  EmptyState emptyState,  List<TorrentRes> torrents,  List<TorrentRes> rawTorrentList,  SortType sortType,  List<String> categoriesRaw,  String? selectedCategoryRaw,  bool isShimmer,  TrendingType trendingType,  Map<TrendingType, List<TorrentRes>> cacheByType,  Set<String> favoriteKeys,  AppNotification? notification)  $default,) {final _that = this;
switch (_that) {
case _TrendingState():
return $default(_that.status,_that.emptyState,_that.torrents,_that.rawTorrentList,_that.sortType,_that.categoriesRaw,_that.selectedCategoryRaw,_that.isShimmer,_that.trendingType,_that.cacheByType,_that.favoriteKeys,_that.notification);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TrendingStatus status,  EmptyState emptyState,  List<TorrentRes> torrents,  List<TorrentRes> rawTorrentList,  SortType sortType,  List<String> categoriesRaw,  String? selectedCategoryRaw,  bool isShimmer,  TrendingType trendingType,  Map<TrendingType, List<TorrentRes>> cacheByType,  Set<String> favoriteKeys,  AppNotification? notification)?  $default,) {final _that = this;
switch (_that) {
case _TrendingState() when $default != null:
return $default(_that.status,_that.emptyState,_that.torrents,_that.rawTorrentList,_that.sortType,_that.categoriesRaw,_that.selectedCategoryRaw,_that.isShimmer,_that.trendingType,_that.cacheByType,_that.favoriteKeys,_that.notification);case _:
  return null;

}
}

}

/// @nodoc


class _TrendingState implements TrendingState {
  const _TrendingState({this.status = TrendingStatus.initial, this.emptyState = const EmptyState(), final  List<TorrentRes> torrents = const <TorrentRes>[], final  List<TorrentRes> rawTorrentList = const <TorrentRes>[], this.sortType = SortType.none, final  List<String> categoriesRaw = const <String>[], this.selectedCategoryRaw, this.isShimmer = false, this.trendingType = TrendingType.day, final  Map<TrendingType, List<TorrentRes>> cacheByType = const <TrendingType, List<TorrentRes>>{}, final  Set<String> favoriteKeys = const <String>{}, this.notification}): _torrents = torrents,_rawTorrentList = rawTorrentList,_categoriesRaw = categoriesRaw,_cacheByType = cacheByType,_favoriteKeys = favoriteKeys;
  

@override@JsonKey() final  TrendingStatus status;
@override@JsonKey() final  EmptyState emptyState;
 final  List<TorrentRes> _torrents;
@override@JsonKey() List<TorrentRes> get torrents {
  if (_torrents is EqualUnmodifiableListView) return _torrents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_torrents);
}

 final  List<TorrentRes> _rawTorrentList;
@override@JsonKey() List<TorrentRes> get rawTorrentList {
  if (_rawTorrentList is EqualUnmodifiableListView) return _rawTorrentList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rawTorrentList);
}

@override@JsonKey() final  SortType sortType;
 final  List<String> _categoriesRaw;
@override@JsonKey() List<String> get categoriesRaw {
  if (_categoriesRaw is EqualUnmodifiableListView) return _categoriesRaw;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categoriesRaw);
}

@override final  String? selectedCategoryRaw;
@override@JsonKey() final  bool isShimmer;
@override@JsonKey() final  TrendingType trendingType;
 final  Map<TrendingType, List<TorrentRes>> _cacheByType;
@override@JsonKey() Map<TrendingType, List<TorrentRes>> get cacheByType {
  if (_cacheByType is EqualUnmodifiableMapView) return _cacheByType;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_cacheByType);
}

 final  Set<String> _favoriteKeys;
@override@JsonKey() Set<String> get favoriteKeys {
  if (_favoriteKeys is EqualUnmodifiableSetView) return _favoriteKeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_favoriteKeys);
}

@override final  AppNotification? notification;

/// Create a copy of TrendingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrendingStateCopyWith<_TrendingState> get copyWith => __$TrendingStateCopyWithImpl<_TrendingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrendingState&&(identical(other.status, status) || other.status == status)&&(identical(other.emptyState, emptyState) || other.emptyState == emptyState)&&const DeepCollectionEquality().equals(other._torrents, _torrents)&&const DeepCollectionEquality().equals(other._rawTorrentList, _rawTorrentList)&&(identical(other.sortType, sortType) || other.sortType == sortType)&&const DeepCollectionEquality().equals(other._categoriesRaw, _categoriesRaw)&&(identical(other.selectedCategoryRaw, selectedCategoryRaw) || other.selectedCategoryRaw == selectedCategoryRaw)&&(identical(other.isShimmer, isShimmer) || other.isShimmer == isShimmer)&&(identical(other.trendingType, trendingType) || other.trendingType == trendingType)&&const DeepCollectionEquality().equals(other._cacheByType, _cacheByType)&&const DeepCollectionEquality().equals(other._favoriteKeys, _favoriteKeys)&&(identical(other.notification, notification) || other.notification == notification));
}


@override
int get hashCode => Object.hash(runtimeType,status,emptyState,const DeepCollectionEquality().hash(_torrents),const DeepCollectionEquality().hash(_rawTorrentList),sortType,const DeepCollectionEquality().hash(_categoriesRaw),selectedCategoryRaw,isShimmer,trendingType,const DeepCollectionEquality().hash(_cacheByType),const DeepCollectionEquality().hash(_favoriteKeys),notification);

@override
String toString() {
  return 'TrendingState(status: $status, emptyState: $emptyState, torrents: $torrents, rawTorrentList: $rawTorrentList, sortType: $sortType, categoriesRaw: $categoriesRaw, selectedCategoryRaw: $selectedCategoryRaw, isShimmer: $isShimmer, trendingType: $trendingType, cacheByType: $cacheByType, favoriteKeys: $favoriteKeys, notification: $notification)';
}


}

/// @nodoc
abstract mixin class _$TrendingStateCopyWith<$Res> implements $TrendingStateCopyWith<$Res> {
  factory _$TrendingStateCopyWith(_TrendingState value, $Res Function(_TrendingState) _then) = __$TrendingStateCopyWithImpl;
@override @useResult
$Res call({
 TrendingStatus status, EmptyState emptyState, List<TorrentRes> torrents, List<TorrentRes> rawTorrentList, SortType sortType, List<String> categoriesRaw, String? selectedCategoryRaw, bool isShimmer, TrendingType trendingType, Map<TrendingType, List<TorrentRes>> cacheByType, Set<String> favoriteKeys, AppNotification? notification
});


@override $EmptyStateCopyWith<$Res> get emptyState;

}
/// @nodoc
class __$TrendingStateCopyWithImpl<$Res>
    implements _$TrendingStateCopyWith<$Res> {
  __$TrendingStateCopyWithImpl(this._self, this._then);

  final _TrendingState _self;
  final $Res Function(_TrendingState) _then;

/// Create a copy of TrendingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? emptyState = null,Object? torrents = null,Object? rawTorrentList = null,Object? sortType = null,Object? categoriesRaw = null,Object? selectedCategoryRaw = freezed,Object? isShimmer = null,Object? trendingType = null,Object? cacheByType = null,Object? favoriteKeys = null,Object? notification = freezed,}) {
  return _then(_TrendingState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TrendingStatus,emptyState: null == emptyState ? _self.emptyState : emptyState // ignore: cast_nullable_to_non_nullable
as EmptyState,torrents: null == torrents ? _self._torrents : torrents // ignore: cast_nullable_to_non_nullable
as List<TorrentRes>,rawTorrentList: null == rawTorrentList ? _self._rawTorrentList : rawTorrentList // ignore: cast_nullable_to_non_nullable
as List<TorrentRes>,sortType: null == sortType ? _self.sortType : sortType // ignore: cast_nullable_to_non_nullable
as SortType,categoriesRaw: null == categoriesRaw ? _self._categoriesRaw : categoriesRaw // ignore: cast_nullable_to_non_nullable
as List<String>,selectedCategoryRaw: freezed == selectedCategoryRaw ? _self.selectedCategoryRaw : selectedCategoryRaw // ignore: cast_nullable_to_non_nullable
as String?,isShimmer: null == isShimmer ? _self.isShimmer : isShimmer // ignore: cast_nullable_to_non_nullable
as bool,trendingType: null == trendingType ? _self.trendingType : trendingType // ignore: cast_nullable_to_non_nullable
as TrendingType,cacheByType: null == cacheByType ? _self._cacheByType : cacheByType // ignore: cast_nullable_to_non_nullable
as Map<TrendingType, List<TorrentRes>>,favoriteKeys: null == favoriteKeys ? _self._favoriteKeys : favoriteKeys // ignore: cast_nullable_to_non_nullable
as Set<String>,notification: freezed == notification ? _self.notification : notification // ignore: cast_nullable_to_non_nullable
as AppNotification?,
  ));
}

/// Create a copy of TrendingState
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
