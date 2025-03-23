// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trending_req.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrendingReq {

 String get token; String get uuid; String get sort; String get top; String get nsfw;
/// Create a copy of TrendingReq
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrendingReqCopyWith<TrendingReq> get copyWith => _$TrendingReqCopyWithImpl<TrendingReq>(this as TrendingReq, _$identity);

  /// Serializes this TrendingReq to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrendingReq&&(identical(other.token, token) || other.token == token)&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.top, top) || other.top == top)&&(identical(other.nsfw, nsfw) || other.nsfw == nsfw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,uuid,sort,top,nsfw);

@override
String toString() {
  return 'TrendingReq(token: $token, uuid: $uuid, sort: $sort, top: $top, nsfw: $nsfw)';
}


}

/// @nodoc
abstract mixin class $TrendingReqCopyWith<$Res>  {
  factory $TrendingReqCopyWith(TrendingReq value, $Res Function(TrendingReq) _then) = _$TrendingReqCopyWithImpl;
@useResult
$Res call({
 String token, String uuid, String sort, String top, String nsfw
});




}
/// @nodoc
class _$TrendingReqCopyWithImpl<$Res>
    implements $TrendingReqCopyWith<$Res> {
  _$TrendingReqCopyWithImpl(this._self, this._then);

  final TrendingReq _self;
  final $Res Function(TrendingReq) _then;

/// Create a copy of TrendingReq
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? uuid = null,Object? sort = null,Object? top = null,Object? nsfw = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as String,top: null == top ? _self.top : top // ignore: cast_nullable_to_non_nullable
as String,nsfw: null == nsfw ? _self.nsfw : nsfw // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _TrendingReq extends TrendingReq {
  const _TrendingReq({required this.token, required this.uuid, required this.sort, required this.top, required this.nsfw}): super._();
  factory _TrendingReq.fromJson(Map<String, dynamic> json) => _$TrendingReqFromJson(json);

@override final  String token;
@override final  String uuid;
@override final  String sort;
@override final  String top;
@override final  String nsfw;

/// Create a copy of TrendingReq
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrendingReqCopyWith<_TrendingReq> get copyWith => __$TrendingReqCopyWithImpl<_TrendingReq>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrendingReqToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrendingReq&&(identical(other.token, token) || other.token == token)&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.top, top) || other.top == top)&&(identical(other.nsfw, nsfw) || other.nsfw == nsfw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,uuid,sort,top,nsfw);

@override
String toString() {
  return 'TrendingReq(token: $token, uuid: $uuid, sort: $sort, top: $top, nsfw: $nsfw)';
}


}

/// @nodoc
abstract mixin class _$TrendingReqCopyWith<$Res> implements $TrendingReqCopyWith<$Res> {
  factory _$TrendingReqCopyWith(_TrendingReq value, $Res Function(_TrendingReq) _then) = __$TrendingReqCopyWithImpl;
@override @useResult
$Res call({
 String token, String uuid, String sort, String top, String nsfw
});




}
/// @nodoc
class __$TrendingReqCopyWithImpl<$Res>
    implements _$TrendingReqCopyWith<$Res> {
  __$TrendingReqCopyWithImpl(this._self, this._then);

  final _TrendingReq _self;
  final $Res Function(_TrendingReq) _then;

/// Create a copy of TrendingReq
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? uuid = null,Object? sort = null,Object? top = null,Object? nsfw = null,}) {
  return _then(_TrendingReq(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as String,top: null == top ? _self.top : top // ignore: cast_nullable_to_non_nullable
as String,nsfw: null == nsfw ? _self.nsfw : nsfw // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
