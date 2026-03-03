import 'package:dio/dio.dart';

import '../../../core/helpers/base_exception.dart';
import '../../../core/helpers/base_usecase.dart';
import '../../../core/helpers/data_state.dart';
import '../../../core/utils/string_constants.dart';
import '../../../core/utils/utils.dart';
import '../../data/engine/engine.dart';
import '../repositories/storage_repository.dart';
import 'get_magnet_use_case.dart';

class AddTorrentUseCase
    extends BaseUseCase<TorrentAddedResponse, AddTorrentUseCaseParams> {
  AddTorrentUseCase({
    required Engine engine,
    required StorageRepository storageRepository,
    GetMagnetUseCase? getMagnetUseCase,
  }) : _engine = engine,
       _storageRepository = storageRepository,
       _getMagnetUseCase = getMagnetUseCase;

  final Engine _engine;
  final StorageRepository _storageRepository;
  final GetMagnetUseCase? _getMagnetUseCase;
  String? _cachedDownloadDir;

  Future<bool> hasCoins() async {
    final result = await _storageRepository.getCoins();
    return result is DataSuccess<int> && (result.data ?? 0) > 0;
  }

  @override
  Future<DataState<TorrentAddedResponse>> call(
    AddTorrentUseCaseParams params, {
    required CancelToken cancelToken,
    String? metainfo,
  }) async {
    try {
      final coinsResult = await _storageRepository.getCoins();

      if (coinsResult case DataSuccess<int>(
        data: final coins?,
      ) when coins > 0) {
        _cachedDownloadDir ??= await getDownloadDirectory();
        return await _addTorrent(
          params.magnetLink,
          coins,
          metainfo,
          _cachedDownloadDir!,
        );
      }

      return DataFailed(
        BaseException(
          type: coinsResult is DataSuccess
              ? BaseExceptionType.insufficientCoins
              : BaseExceptionType.unknown,
          message: coinsResult is DataSuccess
              ? insufficientCoins
              : failedToRetrieveCoins,
        ),
      );
    } catch (e) {
      return DataFailed(
        BaseException(
          type: BaseExceptionType.unknown,
          message: '$failedToAddTorrent: ${e.toString()}',
        ),
      );
    }
  }

  Future<BatchAddResult> callBatch(
    List<BatchTorrentItem> items,
    CancelToken cancelToken,
  ) async {
    final coinsResult = await _storageRepository.getCoins();
    final availableCoins = coinsResult is DataSuccess<int>
        ? (coinsResult.data ?? 0)
        : 0;

    if (availableCoins == 0 || items.isEmpty) {
      return BatchAddResult(
        successCount: 0,
        failureCount: 0,
        skippedCount: items.length,
      );
    }

    final maxProcess = availableCoins < items.length
        ? availableCoins
        : items.length;
    int successCount = 0;
    int failureCount = 0;

    _cachedDownloadDir ??= await getDownloadDirectory();

    for (int i = 0; i < maxProcess; i++) {
      if (cancelToken.isCancelled) break;

      final item = items[i];
      String? magnetLink = item.magnet;

      if (magnetLink.isEmpty && _getMagnetUseCase != null) {
        final res = await _getMagnetUseCase.call(
          item.url,
          cancelToken: cancelToken,
        );
        if (res is DataSuccess<List<String>> && res.data!.isNotEmpty) {
          magnetLink = res.data!.first;
        }
      }

      if (magnetLink.isEmpty) {
        failureCount++;
        continue;
      }

      final response = await _engine.addTorrent(
        magnetLink,
        null,
        _cachedDownloadDir!,
      );
      if (response == TorrentAddedResponse.added) {
        successCount++;
        await _storageRepository.setCoins(availableCoins - successCount);
      } else {
        failureCount++;
      }
    }

    return BatchAddResult(
      successCount: successCount,
      failureCount: failureCount,
      skippedCount: items.length - (successCount + failureCount),
    );
  }

  Future<DataState<TorrentAddedResponse>> _addTorrent(
    String magnetLink,
    int coins,
    String? metainfo,
    String downloadDir,
  ) async {
    final result = await _engine.addTorrent(magnetLink, metainfo, downloadDir);
    if (result == TorrentAddedResponse.added) {
      await _storageRepository.setCoins(coins - 1);
    }
    return DataSuccess(result);
  }
}

class AddTorrentUseCaseParams {
  final String magnetLink;

  const AddTorrentUseCaseParams({required this.magnetLink});
}

class BatchTorrentItem {
  final String url;
  final String magnet;

  const BatchTorrentItem({required this.url, required this.magnet});
}

class BatchAddResult {
  final int successCount;
  final int failureCount;
  final int skippedCount;

  const BatchAddResult({
    required this.successCount,
    required this.failureCount,
    required this.skippedCount,
  });

  String get title {
    if (skippedCount > 0) {
      return successCount > 0
          ? '$successCount $torrentsWereAddedToDownload'
          : '$skippedCount ${skippedCount == 1 ? torrentWasNotDownloaded : torrentsWereNotDownloaded}';
    } else if (successCount > 0 && failureCount > 0) {
      return '$successCount $successSuffix, $failureCount $failedToDownloadTorrents';
    } else if (successCount > 0) {
      return '$successCount $torrentsWereAddedToDownload';
    } else {
      return '$failureCount $failedToDownloadTorrents';
    }
  }

  String get message => skippedCount > 0 && successCount > 0
      ? '$skippedCount ${skippedCount == 1 ? torrentWasNotDownloaded : torrentsWereNotDownloaded}'
      : emptyString;

  bool get isError => successCount == 0;

  bool get hasPartialSuccess => skippedCount > 0 && successCount > 0;
}
