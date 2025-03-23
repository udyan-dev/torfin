// ignore_for_file: depend_on_referenced_packages

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:torfin/core/helper/base_cubit.dart';
import 'package:torfin/src/domain/usecase/get_trending_use_case.dart';

import '../../../../../core/helper/app_exception.dart';
import '../../../../../core/utils/app_constant.dart';
import '../../../../data/model/response/torrent/torrent_res.dart';

part 'trending_cubit.freezed.dart';
part 'trending_state.dart';

class TrendingCubit extends BaseCubit<TrendingState> {
  final GetTrendingUseCase getTrendingUseCase;
  CancelToken? _cancelToken;

  TrendingCubit({required this.getTrendingUseCase})
    : super(const TrendingState());

  Future<void> getTrending({
    TrendingType? trendingType,
    SortType? sortType,
    TorrentType? torrentType,
  }) async {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();

    emit(
      state.copyWith(
        status: TrendingStateEnum.loading,
        sortType: sortType ?? state.sortType,
        trendingType: trendingType ?? state.trendingType,
        torrentType: torrentType ?? state.torrentType,
      ),
    );

    try {
      final response = await getTrendingUseCase.call(
        GetTrendingUseCaseParams(
          top: trendingType?.value ?? state.trendingType.value,
          sort: sortType?.value ?? state.sortType.value,
        ),
        cancelToken: _cancelToken!,
      );

      if (isSuccess(response)) {
        final filteredTorrents = _filterTorrents(
          torrents: response.data!,
          torrentType: torrentType ?? state.torrentType,
        );

        emit(
          state.copyWith(
            torrents: filteredTorrents,
            status: TrendingStateEnum.ready,
          ),
        );
      } else {
        if (response.error?.type != AppExceptionType.cancel &&
            response.error?.type != AppExceptionType.noInternet) {
          emit(
            state.copyWith(
              status: TrendingStateEnum.failure,
              error: response.error?.type ?? AppExceptionType.unknown,
            ),
          );
        }
      }
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        return;
      }

      if (!(_cancelToken?.isCancelled ?? true)) {
        emit(
          state.copyWith(
            status: TrendingStateEnum.failure,
            error: AppExceptionType.unknown,
          ),
        );
      }
    }
  }

  List<TorrentRes> _filterTorrents({
    required List<TorrentRes> torrents,
    required TorrentType torrentType,
  }) {
    return torrentType == TorrentType.all
        ? torrents
        : torrents.where((t) => t.type == torrentType).toList();
  }

  @override
  Future<void> closeToken() async {
    _cancelToken?.cancel();
  }
}
