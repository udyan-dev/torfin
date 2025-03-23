// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:torfin/src/domain/usecase/auto_complete_use_case.dart';
import 'package:torfin/src/domain/usecase/search_torrent_use_case.dart';

import '../../../../../core/helper/app_exception.dart';
import '../../../../../core/helper/base_cubit.dart';
import '../../../../../core/utils/app_constant.dart';
import '../../../../data/model/response/torrent/torrent_res.dart';

part 'search_cubit.freezed.dart';
part 'search_state.dart';

class SearchCubit extends BaseCubit<SearchState> {
  final SearchTorrentUseCase searchTorrentUseCase;
  final AutoCompleteUseCase autoCompleteUseCase;
  CancelToken? _cancelToken;
  CancelToken? _suggestionToken;

  SearchCubit({
    required this.searchTorrentUseCase,
    required this.autoCompleteUseCase,
  }) : super(const SearchState());

  Future<void> search({
    SortType? sortType,
    TorrentType? torrentType,
    String search = "",
    int page = 0,
  }) async {
    // If search query is empty, reset the state
    if (search.trim().isEmpty) {
      emit(
        state.copyWith(
          search: '',
          status: SearchStateEnum.ready,
          torrents: [],
          hasMore: true,
          page: 0, // Reset page to zero
        ),
      );
      return;
    }

    // Cancel the previous request if it's still ongoing
    _cancelToken?.cancel();
    _cancelToken = CancelToken();

    // Emit loading state for the first page, otherwise keep the state as ready
    emit(
      state.copyWith(
        status:
            page == 0 ? SearchStateEnum.loading : SearchStateEnum.pagination,
        sortType: sortType ?? state.sortType,
        torrentType: torrentType ?? state.torrentType,
        search: search,
        page: page,
      ),
    );

    try {
      final response = await searchTorrentUseCase.call(
        SearchTorrentUseCaseParams(
          sort: sortType?.value ?? state.sortType.value,
          search: search,
          page: page,
        ),
        cancelToken: _cancelToken!,
      );

      if (isSuccess(response)) {
        final filteredTorrents = _filterTorrents(
          torrents: response.data!,
          torrentType: state.torrentType,
        );

        // Check if there are more items to load
        final hasMore = filteredTorrents.isNotEmpty;

        emit(
          state.copyWith(
            torrents:
                page == 0
                    ? filteredTorrents
                    : [...state.torrents, ...filteredTorrents],
            status: SearchStateEnum.ready,
            hasMore: hasMore,
          ),
        );
      } else {
        // Handle specific errors like no internet or cancellation
        if (response.error?.type != AppExceptionType.cancel &&
            response.error?.type != AppExceptionType.noInternet) {
          emit(
            state.copyWith(
              status: SearchStateEnum.failure,
              error: response.error?.type ?? AppExceptionType.unknown,
            ),
          );
        }
      }
    } catch (e) {
      // Handle Dio cancellation errors
      if (e is DioException && e.type == DioExceptionType.cancel) {
        return; // Silently ignore cancellation errors
      }

      // Handle no internet errors
      if (e is DioException && e.type == DioExceptionType.connectionError) {
        emit(
          state.copyWith(
            status: SearchStateEnum.failure,
            error: AppExceptionType.noInternet,
          ),
        );
        return;
      }

      // Handle other errors
      if (!(_cancelToken?.isCancelled ?? true)) {
        emit(
          state.copyWith(
            status: SearchStateEnum.failure,
            error: AppExceptionType.unknown,
          ),
        );
      }
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.status == SearchStateEnum.pagination) return;

    final nextPage = state.page + 1;
    await search(
      search: state.search,
      sortType: state.sortType,
      torrentType: state.torrentType,
      page: nextPage,
    );
  }

  void clear() {
    emit(const SearchState());
  }

  List<TorrentRes> _filterTorrents({
    required List<TorrentRes> torrents,
    required TorrentType torrentType,
  }) {
    return torrentType == TorrentType.all
        ? torrents
        : torrents.where((t) => t.type == torrentType).toList();
  }

  Future<List<String>> fetchSuggestions({required String query}) async {
    _suggestionToken?.cancel();
    _suggestionToken = CancelToken();

    final response = await autoCompleteUseCase.call(
      query,
      cancelToken: _suggestionToken ?? CancelToken(),
    );
    try {
      if (isSuccess(response)) {
        final suggestion =
            (jsonDecode(response.data as String)[1] as List<dynamic>)
                .map((e) => e.toString())
                .toList();
        return suggestion;
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> closeToken() async {
    _cancelToken?.cancel();
    _suggestionToken?.cancel();
  }
}
