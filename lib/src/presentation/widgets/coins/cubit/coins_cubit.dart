import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coins_state.dart';
part 'coins_cubit.freezed.dart';

class CoinsCubit extends Cubit<CoinsState> {
  CoinsCubit() : super(const CoinsState.initial());
}
