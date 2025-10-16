import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/helpers/data_state.dart';
import '../../../../../core/utils/string_constants.dart';
import '../../../../data/repositories/storage_repository_impl.dart';
import '../../../../domain/repositories/storage_repository.dart';

part 'coins_state.dart';
part 'coins_cubit.freezed.dart';

class CoinsCubit extends Cubit<CoinsState> {
  CoinsCubit({required StorageRepository storageRepository})
    : _storageRepository = storageRepository,
      _storageRepositoryImpl = storageRepository as StorageRepositoryImpl,
      super(const CoinsState()) {
    _subscription = _storageRepositoryImpl.coinsStream.listen((coins) {
      if (!isClosed) emit(state.copyWith(coins: coins));
    }, onError: (_) {});
  }

  final StorageRepository _storageRepository;
  final StorageRepositoryImpl _storageRepositoryImpl;
  StreamSubscription<int>? _subscription;

  Future<void> load() async {
    final result = await _storageRepository.getCoins();
    if (result case DataSuccess<int>(:final data?)) {
      if (!isClosed) emit(state.copyWith(coins: data));
    }
  }

  Future<bool> deduct() async {
    if (state.coins <= 0) return false;
    final newCoins = state.coins - 1;
    final result = await _storageRepository.setCoins(newCoins);
    if (result is DataSuccess<bool> && result.data == true) {
      if (!isClosed) emit(state.copyWith(coins: newCoins));
      return true;
    }
    return false;
  }

  Future<void> add(int amount) async {
    final newCoins = (state.coins + amount).clamp(0, maxCoins);
    final result = await _storageRepository.setCoins(newCoins);
    if (result is DataSuccess<bool> && result.data == true) {
      if (!isClosed) emit(state.copyWith(coins: newCoins));
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
