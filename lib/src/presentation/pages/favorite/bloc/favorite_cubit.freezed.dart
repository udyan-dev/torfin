// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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

 FavoriteStateEnum get status; TorrentType get torrentType; List<TorrentRes> get torrents; String get search; AppExceptionType get error;
/// Create a copy of FavoriteState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteStateCopyWith<FavoriteState> get copyWith => _$FavoriteStateCopyWithImpl<FavoriteState>(this as FavoriteState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteState&&(identical(other.status, status) || other.status == status)&&(identical(other.torrentType, torrentType) || other.torrentType == torrentType)&&const DeepCollectionEquality().equals(other.torrents, torrents)&&(identical(other.search, search) || other.search == search)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,torrentType,const DeepCollectionEquality().hash(torrents),search,error);

@override
String toString() {
  return 'FavoriteState(status: $status, torrentType: $torrentType, torrents: $torrents, search: $search, error: $error)';
}


}

/// @nodoc
abstract mixin class $FavoriteStateCopyWith<$Res>  {
  factory $FavoriteStateCopyWith(FavoriteState value, $Res Function(FavoriteState) _then) = _$FavoriteStateCopyWithImpl;
@useResult
$Res call({
 FavoriteStateEnum status, TorrentType torrentType, List<TorrentRes> torrents, String search, AppExceptionType error
});




}
/// @nodoc
class _$FavoriteStateCopyWithImpl<$Res>
    implements $FavoriteStateCopyWith<$Res> {
  _$FavoriteStateCopyWithImpl(this._self, this._then);

  final FavoriteState _self;
  final $Res Function(FavoriteState) _then;

/// Create a copy of FavoriteState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? torrentType = null,Object? torrents = null,Object? search = null,Object? error = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FavoriteStateEnum,torrentType: null == torrentType ? _self.torrentType : torrentType // ignore: cast_nullable_to_non_nullable
as TorrentType,torrents: null == torrents ? _self.torrents : torrents // ignore: cast_nullable_to_non_nullable
as List<TorrentRes>,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppExceptionType,
  ));
}

}


/// @nodoc


class _FavoriteState extends FavoriteState {
  const _FavoriteState({this.status = FavoriteStateEnum.loading, this.torrentType = TorrentType.all, final  List<TorrentRes> torrents = const [], this.search = "", this.error = AppExceptionType.unknown}): _torrents = torrents,super._();
  

@override@JsonKey() final  FavoriteStateEnum status;
@override@JsonKey() final  TorrentType torrentType;
 final  List<TorrentRes> _torrents;
@override@JsonKey() List<TorrentRes> get torrents {
  if (_torrents is EqualUnmodifiableListView) return _torrents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_torrents);
}

@override@JsonKey() final  String search;
@override@JsonKey() final  AppExceptionType error;

/// Create a copy of FavoriteState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoriteStateCopyWith<_FavoriteState> get copyWith => __$FavoriteStateCopyWithImpl<_FavoriteState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoriteState&&(identical(other.status, status) || other.status == status)&&(identical(other.torrentType, torrentType) || other.torrentType == torrentType)&&const DeepCollectionEquality().equals(other._torrents, _torrents)&&(identical(other.search, search) || other.search == search)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,torrentType,const DeepCollectionEquality().hash(_torrents),search,error);

@override
String toString() {
  return 'FavoriteState(status: $status, torrentType: $torrentType, torrents: $torrents, search: $search, error: $error)';
}


}

/// @nodoc
abstract mixin class _$FavoriteStateCopyWith<$Res> implements $FavoriteStateCopyWith<$Res> {
  factory _$FavoriteStateCopyWith(_FavoriteState value, $Res Function(_FavoriteState) _then) = __$FavoriteStateCopyWithImpl;
@override @useResult
$Res call({
 FavoriteStateEnum status, TorrentType torrentType, List<TorrentRes> torrents, String search, AppExceptionType error
});




}
/// @nodoc
class __$FavoriteStateCopyWithImpl<$Res>
    implements _$FavoriteStateCopyWith<$Res> {
  __$FavoriteStateCopyWithImpl(this._self, this._then);

  final _FavoriteState _self;
  final $Res Function(_FavoriteState) _then;

/// Create a copy of FavoriteState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? torrentType = null,Object? torrents = null,Object? search = null,Object? error = null,}) {
  return _then(_FavoriteState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FavoriteStateEnum,torrentType: null == torrentType ? _self.torrentType : torrentType // ignore: cast_nullable_to_non_nullable
as TorrentType,torrents: null == torrents ? _self._torrents : torrents // ignore: cast_nullable_to_non_nullable
as List<TorrentRes>,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppExceptionType,
  ));
}


}

// dart format on
