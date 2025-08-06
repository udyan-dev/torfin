import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_req.freezed.dart';
part 'search_req.g.dart';

@freezed
abstract class SearchReq with _$SearchReq {

  const factory SearchReq({
    required String token,
    required String uuid,
    required String sort,
    required String nsfw,
    required String search,
    required int page,
  }) = _SearchReq;
  const SearchReq._();

  factory SearchReq.fromJson(Map<String, Object?> json) =>
      _$SearchReqFromJson(json);
}
