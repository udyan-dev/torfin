// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'torrent_res.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
TorrentRes _$TorrentResFromJson(
  Map<String, dynamic> json
) {
    return _Torrent.fromJson(
      json
    );
}

/// @nodoc
mixin _$TorrentRes {

 String get magnet; String get age; String get name; String get size; int get seeder; int get leecher; String get type; String get site; String get url; bool get trusted; bool get nsfw;
/// Create a copy of TorrentRes
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TorrentResCopyWith<TorrentRes> get copyWith => _$TorrentResCopyWithImpl<TorrentRes>(this as TorrentRes, _$identity);

  /// Serializes this TorrentRes to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TorrentRes&&(identical(other.magnet, magnet) || other.magnet == magnet)&&(identical(other.age, age) || other.age == age)&&(identical(other.name, name) || other.name == name)&&(identical(other.size, size) || other.size == size)&&(identical(other.seeder, seeder) || other.seeder == seeder)&&(identical(other.leecher, leecher) || other.leecher == leecher)&&(identical(other.type, type) || other.type == type)&&(identical(other.site, site) || other.site == site)&&(identical(other.url, url) || other.url == url)&&(identical(other.trusted, trusted) || other.trusted == trusted)&&(identical(other.nsfw, nsfw) || other.nsfw == nsfw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,magnet,age,name,size,seeder,leecher,type,site,url,trusted,nsfw);

@override
String toString() {
  return 'TorrentRes(magnet: $magnet, age: $age, name: $name, size: $size, seeder: $seeder, leecher: $leecher, type: $type, site: $site, url: $url, trusted: $trusted, nsfw: $nsfw)';
}


}

/// @nodoc
abstract mixin class $TorrentResCopyWith<$Res>  {
  factory $TorrentResCopyWith(TorrentRes value, $Res Function(TorrentRes) _then) = _$TorrentResCopyWithImpl;
@useResult
$Res call({
 String magnet, String age, String name, String size, int seeder, int leecher, String type, String site, String url, bool trusted, bool nsfw
});




}
/// @nodoc
class _$TorrentResCopyWithImpl<$Res>
    implements $TorrentResCopyWith<$Res> {
  _$TorrentResCopyWithImpl(this._self, this._then);

  final TorrentRes _self;
  final $Res Function(TorrentRes) _then;

/// Create a copy of TorrentRes
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? magnet = null,Object? age = null,Object? name = null,Object? size = null,Object? seeder = null,Object? leecher = null,Object? type = null,Object? site = null,Object? url = null,Object? trusted = null,Object? nsfw = null,}) {
  return _then(_self.copyWith(
magnet: null == magnet ? _self.magnet : magnet // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String,seeder: null == seeder ? _self.seeder : seeder // ignore: cast_nullable_to_non_nullable
as int,leecher: null == leecher ? _self.leecher : leecher // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,trusted: null == trusted ? _self.trusted : trusted // ignore: cast_nullable_to_non_nullable
as bool,nsfw: null == nsfw ? _self.nsfw : nsfw // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TorrentRes].
extension TorrentResPatterns on TorrentRes {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Torrent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Torrent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Torrent value)  $default,){
final _that = this;
switch (_that) {
case _Torrent():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Torrent value)?  $default,){
final _that = this;
switch (_that) {
case _Torrent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String magnet,  String age,  String name,  String size,  int seeder,  int leecher,  String type,  String site,  String url,  bool trusted,  bool nsfw)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Torrent() when $default != null:
return $default(_that.magnet,_that.age,_that.name,_that.size,_that.seeder,_that.leecher,_that.type,_that.site,_that.url,_that.trusted,_that.nsfw);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String magnet,  String age,  String name,  String size,  int seeder,  int leecher,  String type,  String site,  String url,  bool trusted,  bool nsfw)  $default,) {final _that = this;
switch (_that) {
case _Torrent():
return $default(_that.magnet,_that.age,_that.name,_that.size,_that.seeder,_that.leecher,_that.type,_that.site,_that.url,_that.trusted,_that.nsfw);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String magnet,  String age,  String name,  String size,  int seeder,  int leecher,  String type,  String site,  String url,  bool trusted,  bool nsfw)?  $default,) {final _that = this;
switch (_that) {
case _Torrent() when $default != null:
return $default(_that.magnet,_that.age,_that.name,_that.size,_that.seeder,_that.leecher,_that.type,_that.site,_that.url,_that.trusted,_that.nsfw);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Torrent extends TorrentRes {
  const _Torrent({this.magnet = '', this.age = '', this.name = '', this.size = '', this.seeder = 0, this.leecher = 0, this.type = '', this.site = '', this.url = '', this.trusted = false, this.nsfw = false}): super._();
  factory _Torrent.fromJson(Map<String, dynamic> json) => _$TorrentFromJson(json);

@override@JsonKey() final  String magnet;
@override@JsonKey() final  String age;
@override@JsonKey() final  String name;
@override@JsonKey() final  String size;
@override@JsonKey() final  int seeder;
@override@JsonKey() final  int leecher;
@override@JsonKey() final  String type;
@override@JsonKey() final  String site;
@override@JsonKey() final  String url;
@override@JsonKey() final  bool trusted;
@override@JsonKey() final  bool nsfw;

/// Create a copy of TorrentRes
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TorrentCopyWith<_Torrent> get copyWith => __$TorrentCopyWithImpl<_Torrent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TorrentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Torrent&&(identical(other.magnet, magnet) || other.magnet == magnet)&&(identical(other.age, age) || other.age == age)&&(identical(other.name, name) || other.name == name)&&(identical(other.size, size) || other.size == size)&&(identical(other.seeder, seeder) || other.seeder == seeder)&&(identical(other.leecher, leecher) || other.leecher == leecher)&&(identical(other.type, type) || other.type == type)&&(identical(other.site, site) || other.site == site)&&(identical(other.url, url) || other.url == url)&&(identical(other.trusted, trusted) || other.trusted == trusted)&&(identical(other.nsfw, nsfw) || other.nsfw == nsfw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,magnet,age,name,size,seeder,leecher,type,site,url,trusted,nsfw);

@override
String toString() {
  return 'TorrentRes(magnet: $magnet, age: $age, name: $name, size: $size, seeder: $seeder, leecher: $leecher, type: $type, site: $site, url: $url, trusted: $trusted, nsfw: $nsfw)';
}


}

/// @nodoc
abstract mixin class _$TorrentCopyWith<$Res> implements $TorrentResCopyWith<$Res> {
  factory _$TorrentCopyWith(_Torrent value, $Res Function(_Torrent) _then) = __$TorrentCopyWithImpl;
@override @useResult
$Res call({
 String magnet, String age, String name, String size, int seeder, int leecher, String type, String site, String url, bool trusted, bool nsfw
});




}
/// @nodoc
class __$TorrentCopyWithImpl<$Res>
    implements _$TorrentCopyWith<$Res> {
  __$TorrentCopyWithImpl(this._self, this._then);

  final _Torrent _self;
  final $Res Function(_Torrent) _then;

/// Create a copy of TorrentRes
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? magnet = null,Object? age = null,Object? name = null,Object? size = null,Object? seeder = null,Object? leecher = null,Object? type = null,Object? site = null,Object? url = null,Object? trusted = null,Object? nsfw = null,}) {
  return _then(_Torrent(
magnet: null == magnet ? _self.magnet : magnet // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String,seeder: null == seeder ? _self.seeder : seeder // ignore: cast_nullable_to_non_nullable
as int,leecher: null == leecher ? _self.leecher : leecher // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,trusted: null == trusted ? _self.trusted : trusted // ignore: cast_nullable_to_non_nullable
as bool,nsfw: null == nsfw ? _self.nsfw : nsfw // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
