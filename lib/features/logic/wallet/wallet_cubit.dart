import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/utils/toast_states/enums.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/wallet/wallet_model.dart';
import 'package:weltweit/features/domain/usecase/provider_wallet/wallet_history_usecase.dart';

import '../../domain/usecase/provider_wallet/convert_points_provider_usecase.dart';
import '../../domain/usecase/user_wallet/convert_points_usecase.dart';
import '../../domain/usecase/user_wallet/user_wallet_usecase.dart';
import '../profile/profile_cubit.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletHistoryUseCase walletHistoryUseCase;
  final ConvertPointsUseCase convertPointsUseCase;
  final WalletUserUseCase walletUserUseCase;
  final ConvertPointsProviderUseCase convertPointsProviderUseCase;
  WalletCubit(
    this.convertPointsUseCase,
    this.walletUserUseCase,
    this.convertPointsProviderUseCase,
    this.walletHistoryUseCase,
  ) : super(const WalletState());

  ///Provider
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
  Future<void> convertProviderPoints() async {
    emit(state.copyWith(convertState: BaseState.loading));
    final result = await convertPointsProviderUseCase(NoParameters());

    result.fold(
          (error) => emit(state.copyWith(convertState: BaseState.error, error: error)),
          (data) {
        emit(state.copyWith(convertState: BaseState.loaded));
      },
    );
  }



  ///User
  Future<void> getUserWallet() async {
    initStates();
    emit(state.copyWith(state: BaseState.loading));
    final result = await walletUserUseCase(NoParameters());

    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(state: BaseState.loaded, data: data));
      },
    );
  }
  Future<void> convertUserPoints() async {
    emit(state.copyWith(convertState: BaseState.loading));
    final result = await convertPointsUseCase(NoParameters());

    result.fold(
      (error) => emit(state.copyWith(convertState: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(convertState: BaseState.loaded));
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
