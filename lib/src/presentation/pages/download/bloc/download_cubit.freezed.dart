// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'download_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DownloadState {

 DownloadStateEnum get status; AppExceptionType get error; Session? get session; List<Torrent> get torrents; List<Torrent> get displayedTorrents; List<String> get labels; String get filterText; bool get hasLoaded; Sort get sort; bool get reverseSort; Filters? get filters;
/// Create a copy of DownloadState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadStateCopyWith<DownloadState> get copyWith => _$DownloadStateCopyWithImpl<DownloadState>(this as DownloadState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadState&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.session, session) || other.session == session)&&const DeepCollectionEquality().equals(other.torrents, torrents)&&const DeepCollectionEquality().equals(other.displayedTorrents, displayedTorrents)&&const DeepCollectionEquality().equals(other.labels, labels)&&(identical(other.filterText, filterText) || other.filterText == filterText)&&(identical(other.hasLoaded, hasLoaded) || other.hasLoaded == hasLoaded)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.reverseSort, reverseSort) || other.reverseSort == reverseSort)&&(identical(other.filters, filters) || other.filters == filters));
}


@override
int get hashCode => Object.hash(runtimeType,status,error,session,const DeepCollectionEquality().hash(torrents),const DeepCollectionEquality().hash(displayedTorrents),const DeepCollectionEquality().hash(labels),filterText,hasLoaded,sort,reverseSort,filters);

@override
String toString() {
  return 'DownloadState(status: $status, error: $error, session: $session, torrents: $torrents, displayedTorrents: $displayedTorrents, labels: $labels, filterText: $filterText, hasLoaded: $hasLoaded, sort: $sort, reverseSort: $reverseSort, filters: $filters)';
}


}

/// @nodoc
abstract mixin class $DownloadStateCopyWith<$Res>  {
  factory $DownloadStateCopyWith(DownloadState value, $Res Function(DownloadState) _then) = _$DownloadStateCopyWithImpl;
@useResult
$Res call({
 DownloadStateEnum status, AppExceptionType error, Session? session, List<Torrent> torrents, List<Torrent> displayedTorrents, List<String> labels, String filterText, bool hasLoaded, Sort sort, bool reverseSort, Filters? filters
});




}
/// @nodoc
class _$DownloadStateCopyWithImpl<$Res>
    implements $DownloadStateCopyWith<$Res> {
  _$DownloadStateCopyWithImpl(this._self, this._then);

  final DownloadState _self;
  final $Res Function(DownloadState) _then;

/// Create a copy of DownloadState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? error = null,Object? session = freezed,Object? torrents = null,Object? displayedTorrents = null,Object? labels = null,Object? filterText = null,Object? hasLoaded = null,Object? sort = null,Object? reverseSort = null,Object? filters = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DownloadStateEnum,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppExceptionType,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as Session?,torrents: null == torrents ? _self.torrents : torrents // ignore: cast_nullable_to_non_nullable
as List<Torrent>,displayedTorrents: null == displayedTorrents ? _self.displayedTorrents : displayedTorrents // ignore: cast_nullable_to_non_nullable
as List<Torrent>,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<String>,filterText: null == filterText ? _self.filterText : filterText // ignore: cast_nullable_to_non_nullable
as String,hasLoaded: null == hasLoaded ? _self.hasLoaded : hasLoaded // ignore: cast_nullable_to_non_nullable
as bool,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as Sort,reverseSort: null == reverseSort ? _self.reverseSort : reverseSort // ignore: cast_nullable_to_non_nullable
as bool,filters: freezed == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as Filters?,
  ));
}

}


/// @nodoc


class _DownloadState extends DownloadState {
  const _DownloadState({this.status = DownloadStateEnum.initial, this.error = AppExceptionType.unknown, this.session, final  List<Torrent> torrents = const [], final  List<Torrent> displayedTorrents = const [], final  List<String> labels = const [], this.filterText = '', this.hasLoaded = false, this.sort = Sort.addedDate, this.reverseSort = true, this.filters}): _torrents = torrents,_displayedTorrents = displayedTorrents,_labels = labels,super._();
  

@override@JsonKey() final  DownloadStateEnum status;
@override@JsonKey() final  AppExceptionType error;
@override final  Session? session;
 final  List<Torrent> _torrents;
@override@JsonKey() List<Torrent> get torrents {
  if (_torrents is EqualUnmodifiableListView) return _torrents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_torrents);
}

 final  List<Torrent> _displayedTorrents;
@override@JsonKey() List<Torrent> get displayedTorrents {
  if (_displayedTorrents is EqualUnmodifiableListView) return _displayedTorrents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_displayedTorrents);
}

 final  List<String> _labels;
@override@JsonKey() List<String> get labels {
  if (_labels is EqualUnmodifiableListView) return _labels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_labels);
}

@override@JsonKey() final  String filterText;
@override@JsonKey() final  bool hasLoaded;
@override@JsonKey() final  Sort sort;
@override@JsonKey() final  bool reverseSort;
@override final  Filters? filters;

/// Create a copy of DownloadState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DownloadStateCopyWith<_DownloadState> get copyWith => __$DownloadStateCopyWithImpl<_DownloadState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DownloadState&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.session, session) || other.session == session)&&const DeepCollectionEquality().equals(other._torrents, _torrents)&&const DeepCollectionEquality().equals(other._displayedTorrents, _displayedTorrents)&&const DeepCollectionEquality().equals(other._labels, _labels)&&(identical(other.filterText, filterText) || other.filterText == filterText)&&(identical(other.hasLoaded, hasLoaded) || other.hasLoaded == hasLoaded)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.reverseSort, reverseSort) || other.reverseSort == reverseSort)&&(identical(other.filters, filters) || other.filters == filters));
}


@override
int get hashCode => Object.hash(runtimeType,status,error,session,const DeepCollectionEquality().hash(_torrents),const DeepCollectionEquality().hash(_displayedTorrents),const DeepCollectionEquality().hash(_labels),filterText,hasLoaded,sort,reverseSort,filters);

@override
String toString() {
  return 'DownloadState(status: $status, error: $error, session: $session, torrents: $torrents, displayedTorrents: $displayedTorrents, labels: $labels, filterText: $filterText, hasLoaded: $hasLoaded, sort: $sort, reverseSort: $reverseSort, filters: $filters)';
}


}

/// @nodoc
abstract mixin class _$DownloadStateCopyWith<$Res> implements $DownloadStateCopyWith<$Res> {
  factory _$DownloadStateCopyWith(_DownloadState value, $Res Function(_DownloadState) _then) = __$DownloadStateCopyWithImpl;
@override @useResult
$Res call({
 DownloadStateEnum status, AppExceptionType error, Session? session, List<Torrent> torrents, List<Torrent> displayedTorrents, List<String> labels, String filterText, bool hasLoaded, Sort sort, bool reverseSort, Filters? filters
});




}
/// @nodoc
class __$DownloadStateCopyWithImpl<$Res>
    implements _$DownloadStateCopyWith<$Res> {
  __$DownloadStateCopyWithImpl(this._self, this._then);

  final _DownloadState _self;
  final $Res Function(_DownloadState) _then;

/// Create a copy of DownloadState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? error = null,Object? session = freezed,Object? torrents = null,Object? displayedTorrents = null,Object? labels = null,Object? filterText = null,Object? hasLoaded = null,Object? sort = null,Object? reverseSort = null,Object? filters = freezed,}) {
  return _then(_DownloadState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DownloadStateEnum,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppExceptionType,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as Session?,torrents: null == torrents ? _self._torrents : torrents // ignore: cast_nullable_to_non_nullable
as List<Torrent>,displayedTorrents: null == displayedTorrents ? _self._displayedTorrents : displayedTorrents // ignore: cast_nullable_to_non_nullable
as List<Torrent>,labels: null == labels ? _self._labels : labels // ignore: cast_nullable_to_non_nullable
as List<String>,filterText: null == filterText ? _self.filterText : filterText // ignore: cast_nullable_to_non_nullable
as String,hasLoaded: null == hasLoaded ? _self.hasLoaded : hasLoaded // ignore: cast_nullable_to_non_nullable
as bool,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as Sort,reverseSort: null == reverseSort ? _self.reverseSort : reverseSort // ignore: cast_nullable_to_non_nullable
as bool,filters: freezed == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as Filters?,
  ));
}


}

// dart format on
