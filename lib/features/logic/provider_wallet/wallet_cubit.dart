import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/wallet/wallet_model.dart';
import 'package:weltweit/features/domain/usecase/provider_wallet/wallet_history_usecase.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletHistoryUseCase walletHistoryUseCase;
  WalletCubit(
    this.walletHistoryUseCase,
  ) : super(const WalletState());

  Future<void> getWallet() async {
    initStates();
    emit(state.copyWith(state: BaseState.loading));
    final result = await walletHistoryUseCase(NoParameters());

    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(state: BaseState.loaded, data: data));
      },
    );
  }

  void initStates() {
    emit(state.copyWith(
      state: BaseState.initial,
      error: null,
    ));
  }
}
