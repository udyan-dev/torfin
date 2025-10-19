// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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

 DownloadStatus get status; List<Torrent> get torrents; Session? get session; String? get selectedCategoryRaw; bool get isBulkOperationInProgress;
/// Create a copy of DownloadState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadStateCopyWith<DownloadState> get copyWith => _$DownloadStateCopyWithImpl<DownloadState>(this as DownloadState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.torrents, torrents)&&(identical(other.session, session) || other.session == session)&&(identical(other.selectedCategoryRaw, selectedCategoryRaw) || other.selectedCategoryRaw == selectedCategoryRaw)&&(identical(other.isBulkOperationInProgress, isBulkOperationInProgress) || other.isBulkOperationInProgress == isBulkOperationInProgress));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(torrents),session,selectedCategoryRaw,isBulkOperationInProgress);

@override
String toString() {
  return 'DownloadState(status: $status, torrents: $torrents, session: $session, selectedCategoryRaw: $selectedCategoryRaw, isBulkOperationInProgress: $isBulkOperationInProgress)';
}


}

/// @nodoc
abstract mixin class $DownloadStateCopyWith<$Res>  {
  factory $DownloadStateCopyWith(DownloadState value, $Res Function(DownloadState) _then) = _$DownloadStateCopyWithImpl;
@useResult
$Res call({
 DownloadStatus status, List<Torrent> torrents, Session? session, String? selectedCategoryRaw, bool isBulkOperationInProgress
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
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? torrents = null,Object? session = freezed,Object? selectedCategoryRaw = freezed,Object? isBulkOperationInProgress = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DownloadStatus,torrents: null == torrents ? _self.torrents : torrents // ignore: cast_nullable_to_non_nullable
as List<Torrent>,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as Session?,selectedCategoryRaw: freezed == selectedCategoryRaw ? _self.selectedCategoryRaw : selectedCategoryRaw // ignore: cast_nullable_to_non_nullable
as String?,isBulkOperationInProgress: null == isBulkOperationInProgress ? _self.isBulkOperationInProgress : isBulkOperationInProgress // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DownloadState].
extension DownloadStatePatterns on DownloadState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DownloadState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DownloadState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DownloadState value)  $default,){
final _that = this;
switch (_that) {
case _DownloadState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DownloadState value)?  $default,){
final _that = this;
switch (_that) {
case _DownloadState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DownloadStatus status,  List<Torrent> torrents,  Session? session,  String? selectedCategoryRaw,  bool isBulkOperationInProgress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DownloadState() when $default != null:
return $default(_that.status,_that.torrents,_that.session,_that.selectedCategoryRaw,_that.isBulkOperationInProgress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DownloadStatus status,  List<Torrent> torrents,  Session? session,  String? selectedCategoryRaw,  bool isBulkOperationInProgress)  $default,) {final _that = this;
switch (_that) {
case _DownloadState():
return $default(_that.status,_that.torrents,_that.session,_that.selectedCategoryRaw,_that.isBulkOperationInProgress);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DownloadStatus status,  List<Torrent> torrents,  Session? session,  String? selectedCategoryRaw,  bool isBulkOperationInProgress)?  $default,) {final _that = this;
switch (_that) {
case _DownloadState() when $default != null:
return $default(_that.status,_that.torrents,_that.session,_that.selectedCategoryRaw,_that.isBulkOperationInProgress);case _:
  return null;

}
}

}

/// @nodoc


class _DownloadState implements DownloadState {
  const _DownloadState({this.status = DownloadStatus.initial, final  List<Torrent> torrents = const <Torrent>[], this.session, this.selectedCategoryRaw, this.isBulkOperationInProgress = false}): _torrents = torrents;
  

@override@JsonKey() final  DownloadStatus status;
 final  List<Torrent> _torrents;
@override@JsonKey() List<Torrent> get torrents {
  if (_torrents is EqualUnmodifiableListView) return _torrents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_torrents);
}

@override final  Session? session;
@override final  String? selectedCategoryRaw;
@override@JsonKey() final  bool isBulkOperationInProgress;

/// Create a copy of DownloadState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DownloadStateCopyWith<_DownloadState> get copyWith => __$DownloadStateCopyWithImpl<_DownloadState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DownloadState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._torrents, _torrents)&&(identical(other.session, session) || other.session == session)&&(identical(other.selectedCategoryRaw, selectedCategoryRaw) || other.selectedCategoryRaw == selectedCategoryRaw)&&(identical(other.isBulkOperationInProgress, isBulkOperationInProgress) || other.isBulkOperationInProgress == isBulkOperationInProgress));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_torrents),session,selectedCategoryRaw,isBulkOperationInProgress);

@override
String toString() {
  return 'DownloadState(status: $status, torrents: $torrents, session: $session, selectedCategoryRaw: $selectedCategoryRaw, isBulkOperationInProgress: $isBulkOperationInProgress)';
}


}

/// @nodoc
abstract mixin class _$DownloadStateCopyWith<$Res> implements $DownloadStateCopyWith<$Res> {
  factory _$DownloadStateCopyWith(_DownloadState value, $Res Function(_DownloadState) _then) = __$DownloadStateCopyWithImpl;
@override @useResult
$Res call({
 DownloadStatus status, List<Torrent> torrents, Session? session, String? selectedCategoryRaw, bool isBulkOperationInProgress
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
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? torrents = null,Object? session = freezed,Object? selectedCategoryRaw = freezed,Object? isBulkOperationInProgress = null,}) {
  return _then(_DownloadState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DownloadStatus,torrents: null == torrents ? _self._torrents : torrents // ignore: cast_nullable_to_non_nullable
as List<Torrent>,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as Session?,selectedCategoryRaw: freezed == selectedCategoryRaw ? _self.selectedCategoryRaw : selectedCategoryRaw // ignore: cast_nullable_to_non_nullable
as String?,isBulkOperationInProgress: null == isBulkOperationInProgress ? _self.isBulkOperationInProgress : isBulkOperationInProgress // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
