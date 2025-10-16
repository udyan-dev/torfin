// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchState {

 SearchStatus get status; EmptyState get emptyState; List<TorrentRes> get torrents; List<TorrentRes> get rawTorrentList; String get search; int get page; bool get hasMore; SortType get sortType; List<String> get categoriesRaw; String? get selectedCategoryRaw; bool get isPaginating; bool get isShimmer; String? get currentRequestId; bool get isAutoLoadingMore; Set<String> get favoriteKeys; AppNotification? get notification; String? get fetchingMagnetForKey; bool get isBulkOperationInProgress;
/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchStateCopyWith<SearchState> get copyWith => _$SearchStateCopyWithImpl<SearchState>(this as SearchState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchState&&(identical(other.status, status) || other.status == status)&&(identical(other.emptyState, emptyState) || other.emptyState == emptyState)&&const DeepCollectionEquality().equals(other.torrents, torrents)&&const DeepCollectionEquality().equals(other.rawTorrentList, rawTorrentList)&&(identical(other.search, search) || other.search == search)&&(identical(other.page, page) || other.page == page)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.sortType, sortType) || other.sortType == sortType)&&const DeepCollectionEquality().equals(other.categoriesRaw, categoriesRaw)&&(identical(other.selectedCategoryRaw, selectedCategoryRaw) || other.selectedCategoryRaw == selectedCategoryRaw)&&(identical(other.isPaginating, isPaginating) || other.isPaginating == isPaginating)&&(identical(other.isShimmer, isShimmer) || other.isShimmer == isShimmer)&&(identical(other.currentRequestId, currentRequestId) || other.currentRequestId == currentRequestId)&&(identical(other.isAutoLoadingMore, isAutoLoadingMore) || other.isAutoLoadingMore == isAutoLoadingMore)&&const DeepCollectionEquality().equals(other.favoriteKeys, favoriteKeys)&&(identical(other.notification, notification) || other.notification == notification)&&(identical(other.fetchingMagnetForKey, fetchingMagnetForKey) || other.fetchingMagnetForKey == fetchingMagnetForKey)&&(identical(other.isBulkOperationInProgress, isBulkOperationInProgress) || other.isBulkOperationInProgress == isBulkOperationInProgress));
}


@override
int get hashCode => Object.hash(runtimeType,status,emptyState,const DeepCollectionEquality().hash(torrents),const DeepCollectionEquality().hash(rawTorrentList),search,page,hasMore,sortType,const DeepCollectionEquality().hash(categoriesRaw),selectedCategoryRaw,isPaginating,isShimmer,currentRequestId,isAutoLoadingMore,const DeepCollectionEquality().hash(favoriteKeys),notification,fetchingMagnetForKey,isBulkOperationInProgress);

@override
String toString() {
  return 'SearchState(status: $status, emptyState: $emptyState, torrents: $torrents, rawTorrentList: $rawTorrentList, search: $search, page: $page, hasMore: $hasMore, sortType: $sortType, categoriesRaw: $categoriesRaw, selectedCategoryRaw: $selectedCategoryRaw, isPaginating: $isPaginating, isShimmer: $isShimmer, currentRequestId: $currentRequestId, isAutoLoadingMore: $isAutoLoadingMore, favoriteKeys: $favoriteKeys, notification: $notification, fetchingMagnetForKey: $fetchingMagnetForKey, isBulkOperationInProgress: $isBulkOperationInProgress)';
}


}

/// @nodoc
abstract mixin class $SearchStateCopyWith<$Res>  {
  factory $SearchStateCopyWith(SearchState value, $Res Function(SearchState) _then) = _$SearchStateCopyWithImpl;
@useResult
$Res call({
 SearchStatus status, EmptyState emptyState, List<TorrentRes> torrents, List<TorrentRes> rawTorrentList, String search, int page, bool hasMore, SortType sortType, List<String> categoriesRaw, String? selectedCategoryRaw, bool isPaginating, bool isShimmer, String? currentRequestId, bool isAutoLoadingMore, Set<String> favoriteKeys, AppNotification? notification, String? fetchingMagnetForKey, bool isBulkOperationInProgress
});


$EmptyStateCopyWith<$Res> get emptyState;

}
/// @nodoc
class _$SearchStateCopyWithImpl<$Res>
    implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._self, this._then);

  final SearchState _self;
  final $Res Function(SearchState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? emptyState = null,Object? torrents = null,Object? rawTorrentList = null,Object? search = null,Object? page = null,Object? hasMore = null,Object? sortType = null,Object? categoriesRaw = null,Object? selectedCategoryRaw = freezed,Object? isPaginating = null,Object? isShimmer = null,Object? currentRequestId = freezed,Object? isAutoLoadingMore = null,Object? favoriteKeys = null,Object? notification = freezed,Object? fetchingMagnetForKey = freezed,Object? isBulkOperationInProgress = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SearchStatus,emptyState: null == emptyState ? _self.emptyState : emptyState // ignore: cast_nullable_to_non_nullable
as EmptyState,torrents: null == torrents ? _self.torrents : torrents // ignore: cast_nullable_to_non_nullable
as List<TorrentRes>,rawTorrentList: null == rawTorrentList ? _self.rawTorrentList : rawTorrentList // ignore: cast_nullable_to_non_nullable
as List<TorrentRes>,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,sortType: null == sortType ? _self.sortType : sortType // ignore: cast_nullable_to_non_nullable
as SortType,categoriesRaw: null == categoriesRaw ? _self.categoriesRaw : categoriesRaw // ignore: cast_nullable_to_non_nullable
as List<String>,selectedCategoryRaw: freezed == selectedCategoryRaw ? _self.selectedCategoryRaw : selectedCategoryRaw // ignore: cast_nullable_to_non_nullable
as String?,isPaginating: null == isPaginating ? _self.isPaginating : isPaginating // ignore: cast_nullable_to_non_nullable
as bool,isShimmer: null == isShimmer ? _self.isShimmer : isShimmer // ignore: cast_nullable_to_non_nullable
as bool,currentRequestId: freezed == currentRequestId ? _self.currentRequestId : currentRequestId // ignore: cast_nullable_to_non_nullable
as String?,isAutoLoadingMore: null == isAutoLoadingMore ? _self.isAutoLoadingMore : isAutoLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,favoriteKeys: null == favoriteKeys ? _self.favoriteKeys : favoriteKeys // ignore: cast_nullable_to_non_nullable
as Set<String>,notification: freezed == notification ? _self.notification : notification // ignore: cast_nullable_to_non_nullable
as AppNotification?,fetchingMagnetForKey: freezed == fetchingMagnetForKey ? _self.fetchingMagnetForKey : fetchingMagnetForKey // ignore: cast_nullable_to_non_nullable
as String?,isBulkOperationInProgress: null == isBulkOperationInProgress ? _self.isBulkOperationInProgress : isBulkOperationInProgress // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmptyStateCopyWith<$Res> get emptyState {
  
  return $EmptyStateCopyWith<$Res>(_self.emptyState, (value) {
    return _then(_self.copyWith(emptyState: value));
  });
}
}


/// Adds pattern-matching-related methods to [SearchState].
extension SearchStatePatterns on SearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchState value)  $default,){
final _that = this;
switch (_that) {
case _SearchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchState value)?  $default,){
final _that = this;
switch (_that) {
case _SearchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SearchStatus status,  EmptyState emptyState,  List<TorrentRes> torrents,  List<TorrentRes> rawTorrentList,  String search,  int page,  bool hasMore,  SortType sortType,  List<String> categoriesRaw,  String? selectedCategoryRaw,  bool isPaginating,  bool isShimmer,  String? currentRequestId,  bool isAutoLoadingMore,  Set<String> favoriteKeys,  AppNotification? notification,  String? fetchingMagnetForKey,  bool isBulkOperationInProgress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchState() when $default != null:
return $default(_that.status,_that.emptyState,_that.torrents,_that.rawTorrentList,_that.search,_that.page,_that.hasMore,_that.sortType,_that.categoriesRaw,_that.selectedCategoryRaw,_that.isPaginating,_that.isShimmer,_that.currentRequestId,_that.isAutoLoadingMore,_that.favoriteKeys,_that.notification,_that.fetchingMagnetForKey,_that.isBulkOperationInProgress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SearchStatus status,  EmptyState emptyState,  List<TorrentRes> torrents,  List<TorrentRes> rawTorrentList,  String search,  int page,  bool hasMore,  SortType sortType,  List<String> categoriesRaw,  String? selectedCategoryRaw,  bool isPaginating,  bool isShimmer,  String? currentRequestId,  bool isAutoLoadingMore,  Set<String> favoriteKeys,  AppNotification? notification,  String? fetchingMagnetForKey,  bool isBulkOperationInProgress)  $default,) {final _that = this;
switch (_that) {
case _SearchState():
return $default(_that.status,_that.emptyState,_that.torrents,_that.rawTorrentList,_that.search,_that.page,_that.hasMore,_that.sortType,_that.categoriesRaw,_that.selectedCategoryRaw,_that.isPaginating,_that.isShimmer,_that.currentRequestId,_that.isAutoLoadingMore,_that.favoriteKeys,_that.notification,_that.fetchingMagnetForKey,_that.isBulkOperationInProgress);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SearchStatus status,  EmptyState emptyState,  List<TorrentRes> torrents,  List<TorrentRes> rawTorrentList,  String search,  int page,  bool hasMore,  SortType sortType,  List<String> categoriesRaw,  String? selectedCategoryRaw,  bool isPaginating,  bool isShimmer,  String? currentRequestId,  bool isAutoLoadingMore,  Set<String> favoriteKeys,  AppNotification? notification,  String? fetchingMagnetForKey,  bool isBulkOperationInProgress)?  $default,) {final _that = this;
switch (_that) {
case _SearchState() when $default != null:
return $default(_that.status,_that.emptyState,_that.torrents,_that.rawTorrentList,_that.search,_that.page,_that.hasMore,_that.sortType,_that.categoriesRaw,_that.selectedCategoryRaw,_that.isPaginating,_that.isShimmer,_that.currentRequestId,_that.isAutoLoadingMore,_that.favoriteKeys,_that.notification,_that.fetchingMagnetForKey,_that.isBulkOperationInProgress);case _:
  return null;

}
}

}

/// @nodoc


class _SearchState implements SearchState {
  const _SearchState({this.status = SearchStatus.initial, this.emptyState = const EmptyState(), final  List<TorrentRes> torrents = const [], final  List<TorrentRes> rawTorrentList = const [], this.search = "", this.page = 0, this.hasMore = true, this.sortType = SortType.none, final  List<String> categoriesRaw = const <String>[], this.selectedCategoryRaw, this.isPaginating = false, this.isShimmer = false, this.currentRequestId, this.isAutoLoadingMore = false, final  Set<String> favoriteKeys = const <String>{}, this.notification, this.fetchingMagnetForKey, this.isBulkOperationInProgress = false}): _torrents = torrents,_rawTorrentList = rawTorrentList,_categoriesRaw = categoriesRaw,_favoriteKeys = favoriteKeys;
  

@override@JsonKey() final  SearchStatus status;
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

@override@JsonKey() final  String search;
@override@JsonKey() final  int page;
@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  SortType sortType;
 final  List<String> _categoriesRaw;
@override@JsonKey() List<String> get categoriesRaw {
  if (_categoriesRaw is EqualUnmodifiableListView) return _categoriesRaw;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categoriesRaw);
}

@override final  String? selectedCategoryRaw;
@override@JsonKey() final  bool isPaginating;
@override@JsonKey() final  bool isShimmer;
@override final  String? currentRequestId;
@override@JsonKey() final  bool isAutoLoadingMore;
 final  Set<String> _favoriteKeys;
@override@JsonKey() Set<String> get favoriteKeys {
  if (_favoriteKeys is EqualUnmodifiableSetView) return _favoriteKeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_favoriteKeys);
}

@override final  AppNotification? notification;
@override final  String? fetchingMagnetForKey;
@override@JsonKey() final  bool isBulkOperationInProgress;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchStateCopyWith<_SearchState> get copyWith => __$SearchStateCopyWithImpl<_SearchState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchState&&(identical(other.status, status) || other.status == status)&&(identical(other.emptyState, emptyState) || other.emptyState == emptyState)&&const DeepCollectionEquality().equals(other._torrents, _torrents)&&const DeepCollectionEquality().equals(other._rawTorrentList, _rawTorrentList)&&(identical(other.search, search) || other.search == search)&&(identical(other.page, page) || other.page == page)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.sortType, sortType) || other.sortType == sortType)&&const DeepCollectionEquality().equals(other._categoriesRaw, _categoriesRaw)&&(identical(other.selectedCategoryRaw, selectedCategoryRaw) || other.selectedCategoryRaw == selectedCategoryRaw)&&(identical(other.isPaginating, isPaginating) || other.isPaginating == isPaginating)&&(identical(other.isShimmer, isShimmer) || other.isShimmer == isShimmer)&&(identical(other.currentRequestId, currentRequestId) || other.currentRequestId == currentRequestId)&&(identical(other.isAutoLoadingMore, isAutoLoadingMore) || other.isAutoLoadingMore == isAutoLoadingMore)&&const DeepCollectionEquality().equals(other._favoriteKeys, _favoriteKeys)&&(identical(other.notification, notification) || other.notification == notification)&&(identical(other.fetchingMagnetForKey, fetchingMagnetForKey) || other.fetchingMagnetForKey == fetchingMagnetForKey)&&(identical(other.isBulkOperationInProgress, isBulkOperationInProgress) || other.isBulkOperationInProgress == isBulkOperationInProgress));
}


@override
int get hashCode => Object.hash(runtimeType,status,emptyState,const DeepCollectionEquality().hash(_torrents),const DeepCollectionEquality().hash(_rawTorrentList),search,page,hasMore,sortType,const DeepCollectionEquality().hash(_categoriesRaw),selectedCategoryRaw,isPaginating,isShimmer,currentRequestId,isAutoLoadingMore,const DeepCollectionEquality().hash(_favoriteKeys),notification,fetchingMagnetForKey,isBulkOperationInProgress);

@override
String toString() {
  return 'SearchState(status: $status, emptyState: $emptyState, torrents: $torrents, rawTorrentList: $rawTorrentList, search: $search, page: $page, hasMore: $hasMore, sortType: $sortType, categoriesRaw: $categoriesRaw, selectedCategoryRaw: $selectedCategoryRaw, isPaginating: $isPaginating, isShimmer: $isShimmer, currentRequestId: $currentRequestId, isAutoLoadingMore: $isAutoLoadingMore, favoriteKeys: $favoriteKeys, notification: $notification, fetchingMagnetForKey: $fetchingMagnetForKey, isBulkOperationInProgress: $isBulkOperationInProgress)';
}


}

/// @nodoc
abstract mixin class _$SearchStateCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory _$SearchStateCopyWith(_SearchState value, $Res Function(_SearchState) _then) = __$SearchStateCopyWithImpl;
@override @useResult
$Res call({
 SearchStatus status, EmptyState emptyState, List<TorrentRes> torrents, List<TorrentRes> rawTorrentList, String search, int page, bool hasMore, SortType sortType, List<String> categoriesRaw, String? selectedCategoryRaw, bool isPaginating, bool isShimmer, String? currentRequestId, bool isAutoLoadingMore, Set<String> favoriteKeys, AppNotification? notification, String? fetchingMagnetForKey, bool isBulkOperationInProgress
});


@override $EmptyStateCopyWith<$Res> get emptyState;

}
/// @nodoc
class __$SearchStateCopyWithImpl<$Res>
    implements _$SearchStateCopyWith<$Res> {
  __$SearchStateCopyWithImpl(this._self, this._then);

  final _SearchState _self;
  final $Res Function(_SearchState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? emptyState = null,Object? torrents = null,Object? rawTorrentList = null,Object? search = null,Object? page = null,Object? hasMore = null,Object? sortType = null,Object? categoriesRaw = null,Object? selectedCategoryRaw = freezed,Object? isPaginating = null,Object? isShimmer = null,Object? currentRequestId = freezed,Object? isAutoLoadingMore = null,Object? favoriteKeys = null,Object? notification = freezed,Object? fetchingMagnetForKey = freezed,Object? isBulkOperationInProgress = null,}) {
  return _then(_SearchState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SearchStatus,emptyState: null == emptyState ? _self.emptyState : emptyState // ignore: cast_nullable_to_non_nullable
as EmptyState,torrents: null == torrents ? _self._torrents : torrents // ignore: cast_nullable_to_non_nullable
as List<TorrentRes>,rawTorrentList: null == rawTorrentList ? _self._rawTorrentList : rawTorrentList // ignore: cast_nullable_to_non_nullable
as List<TorrentRes>,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,sortType: null == sortType ? _self.sortType : sortType // ignore: cast_nullable_to_non_nullable
as SortType,categoriesRaw: null == categoriesRaw ? _self._categoriesRaw : categoriesRaw // ignore: cast_nullable_to_non_nullable
as List<String>,selectedCategoryRaw: freezed == selectedCategoryRaw ? _self.selectedCategoryRaw : selectedCategoryRaw // ignore: cast_nullable_to_non_nullable
as String?,isPaginating: null == isPaginating ? _self.isPaginating : isPaginating // ignore: cast_nullable_to_non_nullable
as bool,isShimmer: null == isShimmer ? _self.isShimmer : isShimmer // ignore: cast_nullable_to_non_nullable
as bool,currentRequestId: freezed == currentRequestId ? _self.currentRequestId : currentRequestId // ignore: cast_nullable_to_non_nullable
as String?,isAutoLoadingMore: null == isAutoLoadingMore ? _self.isAutoLoadingMore : isAutoLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,favoriteKeys: null == favoriteKeys ? _self._favoriteKeys : favoriteKeys // ignore: cast_nullable_to_non_nullable
as Set<String>,notification: freezed == notification ? _self.notification : notification // ignore: cast_nullable_to_non_nullable
as AppNotification?,fetchingMagnetForKey: freezed == fetchingMagnetForKey ? _self.fetchingMagnetForKey : fetchingMagnetForKey // ignore: cast_nullable_to_non_nullable
as String?,isBulkOperationInProgress: null == isBulkOperationInProgress ? _self.isBulkOperationInProgress : isBulkOperationInProgress // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SearchState
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
