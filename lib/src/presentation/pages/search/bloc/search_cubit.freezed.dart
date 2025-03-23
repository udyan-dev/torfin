// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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

 SearchStateEnum get status; TorrentType get torrentType; SortType get sortType; List<TorrentRes> get torrents; String get search; int get page; bool get hasMore; AppExceptionType get error;
/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchStateCopyWith<SearchState> get copyWith => _$SearchStateCopyWithImpl<SearchState>(this as SearchState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchState&&(identical(other.status, status) || other.status == status)&&(identical(other.torrentType, torrentType) || other.torrentType == torrentType)&&(identical(other.sortType, sortType) || other.sortType == sortType)&&const DeepCollectionEquality().equals(other.torrents, torrents)&&(identical(other.search, search) || other.search == search)&&(identical(other.page, page) || other.page == page)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,torrentType,sortType,const DeepCollectionEquality().hash(torrents),search,page,hasMore,error);

@override
String toString() {
  return 'SearchState(status: $status, torrentType: $torrentType, sortType: $sortType, torrents: $torrents, search: $search, page: $page, hasMore: $hasMore, error: $error)';
}


}

/// @nodoc
abstract mixin class $SearchStateCopyWith<$Res>  {
  factory $SearchStateCopyWith(SearchState value, $Res Function(SearchState) _then) = _$SearchStateCopyWithImpl;
@useResult
$Res call({
 SearchStateEnum status, TorrentType torrentType, SortType sortType, List<TorrentRes> torrents, String search, int page, bool hasMore, AppExceptionType error
});




}
/// @nodoc
class _$SearchStateCopyWithImpl<$Res>
    implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._self, this._then);

  final SearchState _self;
  final $Res Function(SearchState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? torrentType = null,Object? sortType = null,Object? torrents = null,Object? search = null,Object? page = null,Object? hasMore = null,Object? error = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SearchStateEnum,torrentType: null == torrentType ? _self.torrentType : torrentType // ignore: cast_nullable_to_non_nullable
as TorrentType,sortType: null == sortType ? _self.sortType : sortType // ignore: cast_nullable_to_non_nullable
as SortType,torrents: null == torrents ? _self.torrents : torrents // ignore: cast_nullable_to_non_nullable
as List<TorrentRes>,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppExceptionType,
  ));
}

}


/// @nodoc


class _SearchState extends SearchState {
  const _SearchState({this.status = SearchStateEnum.ready, this.torrentType = TorrentType.all, this.sortType = SortType.none, final  List<TorrentRes> torrents = const [], this.search = "", this.page = 0, this.hasMore = true, this.error = AppExceptionType.unknown}): _torrents = torrents,super._();
  

@override@JsonKey() final  SearchStateEnum status;
@override@JsonKey() final  TorrentType torrentType;
@override@JsonKey() final  SortType sortType;
 final  List<TorrentRes> _torrents;
@override@JsonKey() List<TorrentRes> get torrents {
  if (_torrents is EqualUnmodifiableListView) return _torrents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_torrents);
}

@override@JsonKey() final  String search;
@override@JsonKey() final  int page;
@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  AppExceptionType error;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchStateCopyWith<_SearchState> get copyWith => __$SearchStateCopyWithImpl<_SearchState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchState&&(identical(other.status, status) || other.status == status)&&(identical(other.torrentType, torrentType) || other.torrentType == torrentType)&&(identical(other.sortType, sortType) || other.sortType == sortType)&&const DeepCollectionEquality().equals(other._torrents, _torrents)&&(identical(other.search, search) || other.search == search)&&(identical(other.page, page) || other.page == page)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,torrentType,sortType,const DeepCollectionEquality().hash(_torrents),search,page,hasMore,error);

@override
String toString() {
  return 'SearchState(status: $status, torrentType: $torrentType, sortType: $sortType, torrents: $torrents, search: $search, page: $page, hasMore: $hasMore, error: $error)';
}


}

/// @nodoc
abstract mixin class _$SearchStateCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory _$SearchStateCopyWith(_SearchState value, $Res Function(_SearchState) _then) = __$SearchStateCopyWithImpl;
@override @useResult
$Res call({
 SearchStateEnum status, TorrentType torrentType, SortType sortType, List<TorrentRes> torrents, String search, int page, bool hasMore, AppExceptionType error
});




}
/// @nodoc
class __$SearchStateCopyWithImpl<$Res>
    implements _$SearchStateCopyWith<$Res> {
  __$SearchStateCopyWithImpl(this._self, this._then);

  final _SearchState _self;
  final $Res Function(_SearchState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? torrentType = null,Object? sortType = null,Object? torrents = null,Object? search = null,Object? page = null,Object? hasMore = null,Object? error = null,}) {
  return _then(_SearchState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SearchStateEnum,torrentType: null == torrentType ? _self.torrentType : torrentType // ignore: cast_nullable_to_non_nullable
as TorrentType,sortType: null == sortType ? _self.sortType : sortType // ignore: cast_nullable_to_non_nullable
as SortType,torrents: null == torrents ? _self._torrents : torrents // ignore: cast_nullable_to_non_nullable
as List<TorrentRes>,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppExceptionType,
  ));
}


}

// dart format on
