import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/data/models/provider/provider_rates_model.dart';
import 'package:weltweit/features/data/models/provider/providers_model.dart';
import 'package:weltweit/features/domain/usecase/provider/provider/provider_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider/rates/provider_rates_usecase.dart';

part 'provider_state.dart';

class ProviderCubit extends Cubit<ProviderState> {
  final ProviderUseCase usecase;
  final ProviderRatesUseCase usecaseRates;
  ProviderCubit(
    this.usecase,
    this.usecaseRates,
  ) : super(const ProviderState());

  Future<void> getProvider(int id) async {
    initStates();
    emit(state.copyWith(state: BaseState.loading));
    final result = await usecase(id);

    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(state: BaseState.loaded, data: data));
      },
    );
  }
  Future<void> getRates(int id) async {
    initStates();
    emit(state.copyWith(rateState: BaseState.loading));
    final result = await usecaseRates(id);

    result.fold(
      (error) => emit(state.copyWith(rateState: BaseState.error,)),
      (data) {
        emit(state.copyWith(rateState: BaseState.loaded, dataRates: data));
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
