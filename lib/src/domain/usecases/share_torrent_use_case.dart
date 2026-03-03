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
      final results = await Future.wait([
        _storageRepository.getCoins(),
        _storageRepository.getShareCount(),
      ]);

      final coinsState = results[0];
      final shareState = results[1];

      if (coinsState is DataSuccess<int> && shareState is DataSuccess<int>) {
        final coins = coinsState.data ?? 0;
        final currentCount = shareState.data ?? 0;

        final nextCount = currentCount + 1;
        final isMilestone = nextCount % sharesPerCoin == 0;

        if (coins <= 0 || (isMilestone && coins < 1)) {
          return const DataFailed(
            BaseException(
              type: BaseExceptionType.insufficientCoins,
              message: insufficientCoins,
            ),
          );
        }

        final updates = <Future>[];
        if (isMilestone) updates.add(_storageRepository.setCoins(coins - 1));
        updates.add(
          _storageRepository.setShareCount(isMilestone ? 0 : nextCount),
        );

        await Future.wait(updates);

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
