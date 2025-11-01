import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/helpers/base_exception.dart';
import '../../../core/helpers/base_usecase.dart';
import '../../../core/helpers/data_state.dart';
import '../../../core/utils/string_constants.dart';
import '../repositories/storage_repository.dart';

class ShareTorrentUseCase extends BaseUseCase<void, ShareTorrentUseCaseParams> {
  ShareTorrentUseCase({required StorageRepository storageRepository})
    : _storageRepository = storageRepository;

  final StorageRepository _storageRepository;

  @override
  Future<DataState<void>> call(
    ShareTorrentUseCaseParams params, {
    required CancelToken cancelToken,
  }) async {
    try {
      final coinsResult = await _storageRepository.getCoins();

      if (coinsResult case DataSuccess<int>(:final data?) when data <= 0) {
        return const DataFailed(
          BaseException(
            type: BaseExceptionType.insufficientCoins,
            message: insufficientCoins,
          ),
        );
      }

      final shareCountResult = await _storageRepository.getShareCount();

      if (shareCountResult case DataSuccess<int>(:final data?)) {
        final currentCount = data;
        final newCount = currentCount + 1;

        if (newCount % sharesPerCoin == 0) {
          final coins = coinsResult is DataSuccess<int>
              ? coinsResult.data ?? 0
              : 0;
          await _storageRepository.setCoins(coins - 1);
        }

        final countToSave = newCount % sharesPerCoin == 0 ? 0 : newCount;
        await _storageRepository.setShareCount(countToSave);

        await SharePlus.instance.share(
          ShareParams(text: params.magnetLink, subject: params.torrentName),
        );

        return const DataSuccess(null);
      }

      return const DataFailed(
        BaseException(
          type: BaseExceptionType.unknown,
          message: failedToRetrieveShareCount,
        ),
      );
    } catch (e) {
      return DataFailed(
        BaseException(
          type: BaseExceptionType.unknown,
          message: '$shareFailedPrefix${e.toString()}',
        ),
      );
    }
  }
}

class ShareTorrentUseCaseParams {
  final String magnetLink;
  final String torrentName;

  const ShareTorrentUseCaseParams({
    required this.magnetLink,
    required this.torrentName,
  });
}
