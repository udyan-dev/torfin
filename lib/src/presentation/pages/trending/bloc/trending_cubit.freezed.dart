// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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

 TrendingStateEnum get status; TorrentType get torrentType; SortType get sortType; TrendingType get trendingType; List<TorrentRes> get torrents; AppExceptionType get error;
/// Create a copy of TrendingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrendingStateCopyWith<TrendingState> get copyWith => _$TrendingStateCopyWithImpl<TrendingState>(this as TrendingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrendingState&&(identical(other.status, status) || other.status == status)&&(identical(other.torrentType, torrentType) || other.torrentType == torrentType)&&(identical(other.sortType, sortType) || other.sortType == sortType)&&(identical(other.trendingType, trendingType) || other.trendingType == trendingType)&&const DeepCollectionEquality().equals(other.torrents, torrents)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,torrentType,sortType,trendingType,const DeepCollectionEquality().hash(torrents),error);

@override
String toString() {
  return 'TrendingState(status: $status, torrentType: $torrentType, sortType: $sortType, trendingType: $trendingType, torrents: $torrents, error: $error)';
}


}

/// @nodoc
abstract mixin class $TrendingStateCopyWith<$Res>  {
  factory $TrendingStateCopyWith(TrendingState value, $Res Function(TrendingState) _then) = _$TrendingStateCopyWithImpl;
@useResult
$Res call({
 TrendingStateEnum status, TorrentType torrentType, SortType sortType, TrendingType trendingType, List<TorrentRes> torrents, AppExceptionType error
});




}
/// @nodoc
class _$TrendingStateCopyWithImpl<$Res>
    implements $TrendingStateCopyWith<$Res> {
  _$TrendingStateCopyWithImpl(this._self, this._then);

  final TrendingState _self;
  final $Res Function(TrendingState) _then;

/// Create a copy of TrendingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? torrentType = null,Object? sortType = null,Object? trendingType = null,Object? torrents = null,Object? error = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TrendingStateEnum,torrentType: null == torrentType ? _self.torrentType : torrentType // ignore: cast_nullable_to_non_nullable
as TorrentType,sortType: null == sortType ? _self.sortType : sortType // ignore: cast_nullable_to_non_nullable
as SortType,trendingType: null == trendingType ? _self.trendingType : trendingType // ignore: cast_nullable_to_non_nullable
as TrendingType,torrents: null == torrents ? _self.torrents : torrents // ignore: cast_nullable_to_non_nullable
as List<TorrentRes>,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppExceptionType,
  ));
}

}


/// @nodoc


class _TrendingState extends TrendingState {
  const _TrendingState({this.status = TrendingStateEnum.loading, this.torrentType = TorrentType.all, this.sortType = SortType.none, this.trendingType = TrendingType.day, final  List<TorrentRes> torrents = const [], this.error = AppExceptionType.unknown}): _torrents = torrents,super._();
  

@override@JsonKey() final  TrendingStateEnum status;
@override@JsonKey() final  TorrentType torrentType;
@override@JsonKey() final  SortType sortType;
@override@JsonKey() final  TrendingType trendingType;
 final  List<TorrentRes> _torrents;
@override@JsonKey() List<TorrentRes> get torrents {
  if (_torrents is EqualUnmodifiableListView) return _torrents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_torrents);
}

@override@JsonKey() final  AppExceptionType error;

/// Create a copy of TrendingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrendingStateCopyWith<_TrendingState> get copyWith => __$TrendingStateCopyWithImpl<_TrendingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrendingState&&(identical(other.status, status) || other.status == status)&&(identical(other.torrentType, torrentType) || other.torrentType == torrentType)&&(identical(other.sortType, sortType) || other.sortType == sortType)&&(identical(other.trendingType, trendingType) || other.trendingType == trendingType)&&const DeepCollectionEquality().equals(other._torrents, _torrents)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,torrentType,sortType,trendingType,const DeepCollectionEquality().hash(_torrents),error);

@override
String toString() {
  return 'TrendingState(status: $status, torrentType: $torrentType, sortType: $sortType, trendingType: $trendingType, torrents: $torrents, error: $error)';
}


}

/// @nodoc
abstract mixin class _$TrendingStateCopyWith<$Res> implements $TrendingStateCopyWith<$Res> {
  factory _$TrendingStateCopyWith(_TrendingState value, $Res Function(_TrendingState) _then) = __$TrendingStateCopyWithImpl;
@override @useResult
$Res call({
 TrendingStateEnum status, TorrentType torrentType, SortType sortType, TrendingType trendingType, List<TorrentRes> torrents, AppExceptionType error
});




}
/// @nodoc
class __$TrendingStateCopyWithImpl<$Res>
    implements _$TrendingStateCopyWith<$Res> {
  __$TrendingStateCopyWithImpl(this._self, this._then);

  final _TrendingState _self;
  final $Res Function(_TrendingState) _then;

/// Create a copy of TrendingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? torrentType = null,Object? sortType = null,Object? trendingType = null,Object? torrents = null,Object? error = null,}) {
  return _then(_TrendingState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TrendingStateEnum,torrentType: null == torrentType ? _self.torrentType : torrentType // ignore: cast_nullable_to_non_nullable
as TorrentType,sortType: null == sortType ? _self.sortType : sortType // ignore: cast_nullable_to_non_nullable
as SortType,trendingType: null == trendingType ? _self.trendingType : trendingType // ignore: cast_nullable_to_non_nullable
as TrendingType,torrents: null == torrents ? _self._torrents : torrents // ignore: cast_nullable_to_non_nullable
as List<TorrentRes>,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppExceptionType,
  ));
}


}

// dart format on
