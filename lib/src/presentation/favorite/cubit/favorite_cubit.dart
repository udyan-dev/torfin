import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:torfin/src/data/models/response/torrent/torrent_res.dart';
import 'package:torfin/src/domain/usecases/favorite_use_case.dart';

import '../../../../core/helpers/data_state.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/string_constants.dart';
import '../../../data/models/response/empty_state/empty_state.dart';

part 'favorite_cubit.freezed.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit({required FavoriteUseCase favoriteUseCase})
    : _favoriteUseCase = favoriteUseCase,
      super(const FavoriteState());

  final FavoriteUseCase _favoriteUseCase;

  Future<void> load({String query = ''}) async {
    emit(
      state.copyWith(
        status: FavoriteStatus.loading,
        query: query,
        isShimmer: true,
      ),
    );
    final response = await _favoriteUseCase.call(
      const FavoriteParams(mode: FavoriteMode.getAll),
      cancelToken: CancelToken(),
    );
    response.when(
      success: (data) {
        final safe = data;
        final list = _filter(safe, query);
        final set = <String>{};
        if (safe.isNotEmpty) {
          for (int i = 0; i < safe.length; i++) {
            set.add(safe[i].identityKey);
          }
        }
        emit(
          state.copyWith(
            status: FavoriteStatus.success,
            all: safe,
            torrents: list,
            isShimmer: false,
            favoriteKeys: set,
            emptyState: list.isEmpty
                ? (query.isEmpty
                      ? const EmptyState(
                          stateIcon: AppAssets.icAddFavorite,
                          title: saveYourFavoriteTorrents,
                          description: addTorrentsToYourFavorites,
                        )
                      : const EmptyState(
                          stateIcon: AppAssets.icNoResultFound,
                          title: noResultsFoundTitle,
                          description: noResultsFoundDescription,
                        ))
                : const EmptyState(),
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            status: FavoriteStatus.error,
            isShimmer: false,
            emptyState: EmptyState(
              stateIcon: AppAssets.icNoNetwork,
              title: error.message,
              description: failedToConnectToServer,
              buttonText: retry,
            ),
          ),
        );
      },
    );
  }

  Future<void> toggleFavorite(TorrentRes torrent) async {
    final k = torrent.identityKey;
    final next = state.favoriteKeys.contains(k)
        ? (state.favoriteKeys.toSet()..remove(k))
        : (state.favoriteKeys.toSet()..add(k));
    emit(state.copyWith(favoriteKeys: next));

    final response = await _favoriteUseCase(
      FavoriteParams(mode: FavoriteMode.toggle, torrent: torrent),
      cancelToken: CancelToken(),
    );
    response.when(
      success: (data) {
        final safe = data;
        final list = _filter(safe, state.query);
        final set = <String>{};
        if (safe.isNotEmpty) {
          for (int i = 0; i < safe.length; i++) {
            set.add(safe[i].identityKey);
          }
        }
        EmptyState emptyState;
        if (safe.isEmpty) {
          emptyState = const EmptyState(
            stateIcon: AppAssets.icAddFavorite,
            title: saveYourFavoriteTorrents,
            description: addTorrentsToYourFavorites,
          );
        } else if (list.isEmpty && state.query.isNotEmpty) {
          emptyState = const EmptyState(
            stateIcon: AppAssets.icNoResultFound,
            title: noResultsFoundTitle,
            description: noResultsFoundDescription,
          );
        } else {
          emptyState = const EmptyState();
        }

        emit(
          state.copyWith(
            status: FavoriteStatus.success,
            all: safe,
            torrents: list,
            isShimmer: false,
            favoriteKeys: set,
            emptyState: emptyState,
          ),
        );
      },
    );
  }

  List<TorrentRes> _filter(List<TorrentRes> list, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return list;
    final out = <TorrentRes>[];
    for (int i = 0; i < list.length; i++) {
      final t = list[i];
      final name = t.name.toLowerCase();
      if (name.contains(q)) out.add(t);
    }
    return out;
  }
}
