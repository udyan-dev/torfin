// ignore_for_file: depend_on_referenced_packages

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'search_req.freezed.dart';
part 'search_req.g.dart';

const uuid = Uuid();

@freezed
abstract class SearchReq with _$SearchReq {
  const SearchReq._();

  const factory SearchReq({
    required String token,
    required String uuid,
    required String sort,
    required String nsfw,
    required String search,
    required int page,
  }) = _SearchReq;

  factory SearchReq.fromJson(Map<String, Object?> json) =>
      _$SearchReqFromJson(json);
}
