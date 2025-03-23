// ignore_for_file: depend_on_referenced_packages

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:torfin/core/helper/base_usecase.dart';
import 'package:torfin/src/domain/usecase/get_favorite_use_case.dart';
import 'package:torfin/src/domain/usecase/remove_torrent_use_case.dart';
import 'package:torfin/src/domain/usecase/save_torrent_use_case.dart';

import '../../../../../core/helper/app_exception.dart';
import '../../../../../core/helper/base_cubit.dart';
import '../../../../../core/utils/app_constant.dart';
import '../../../../data/model/response/torrent/torrent_res.dart';

part 'favorite_cubit.freezed.dart';
part 'favorite_state.dart';

class FavoriteCubit extends BaseCubit<FavoriteState> {
  final GetFavoriteUseCase getFavoriteUseCase;
  final SaveTorrentUseCase saveTorrentUseCase;
  final RemoveTorrentUseCase removeTorrentUseCase;

  FavoriteCubit({
    required this.getFavoriteUseCase,
    required this.saveTorrentUseCase,
    required this.removeTorrentUseCase,
  }) : super(const FavoriteState());

  Future<void> getAllFavorites({
    TorrentType? torrentType,
    String? search,
  }) async {
    try {
      final response = await getFavoriteUseCase.call(NoParams());
      if (isSuccess(response)) {
        emit(
          state.copyWith(
            status: FavoriteStateEnum.ready,
            torrents: _filterTorrents(
              torrents: response.data ?? state.torrents,
              torrentType: torrentType ?? state.torrentType,
              search: search?.trim() ?? state.search,
            ),
          ),
        );
      } else {
        emit(state.copyWith(status: FavoriteStateEnum.failure));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: FavoriteStateEnum.failure,
          error: AppExceptionType.unknown,
        ),
      );
    }
  }

  Future<void> saveTorrent({required TorrentRes torrent}) async {
    try {
      await saveTorrentUseCase.call(torrent);
      await getAllFavorites();
    } catch (e) {
      emit(
        state.copyWith(
          status: FavoriteStateEnum.failure,
          error: AppExceptionType.unknown,
        ),
      );
    }
  }

  Future<void> removeTorrent({required TorrentRes torrent}) async {
    try {
      await removeTorrentUseCase.call(torrent);
      await getAllFavorites();
    } catch (e) {
      emit(
        state.copyWith(
          status: FavoriteStateEnum.failure,
          error: AppExceptionType.unknown,
        ),
      );
    }
  }

  List<TorrentRes> _filterTorrents({
    required List<TorrentRes> torrents,
    required TorrentType torrentType,
    required String search,
  }) {
    if (search.isEmpty && torrentType == TorrentType.all) {
      return torrents;
    }

    return torrents.where((t) {
      final matchesType =
          torrentType == TorrentType.all || t.type == torrentType;
      final matchesSearch =
          search.isEmpty || t.name.toLowerCase().contains(search.toLowerCase());

      return matchesType && matchesSearch;
    }).toList();
  }

  @override
  Future<void> closeToken() async {}
}
