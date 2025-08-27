import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'trending_req.freezed.dart';
part 'trending_req.g.dart';

const uuid = Uuid();

@freezed
abstract class TrendingReq with _$TrendingReq {
  const TrendingReq._();

  const factory TrendingReq({
    required String token,
    required String uuid,
    required String sort,
    required String top,
    required String nsfw,
  }) = _TrendingReq;

  factory TrendingReq.fromJson(Map<String, Object?> json) =>
      _$TrendingReqFromJson(json);
}