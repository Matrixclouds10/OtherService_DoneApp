import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/provider/providers_model.dart';
import 'package:weltweit/features/domain/usecase/provider/most_requested_providers_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider/providers_usecase.dart';

part 'providers_state.dart';

class ProvidersCubit extends Cubit<ProvidersState> {
  final MostRequestedProivdersUseCase mostRequestedProivders;
  final ProvidersUseCase allProvidersUseCase;
  ProvidersCubit(
    this.allProvidersUseCase,
    this.mostRequestedProivders,
  ) : super(const ProvidersState());

  Future<void> getProviders(ProvidersParams params) async {
    initStates();
    emit(state.copyWith(state: BaseState.loading));
    final result = await allProvidersUseCase(params);

    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(state: BaseState.loaded, providers: data));
      },
    );
  }

  Future<List<ProvidersModel>> getMostRequestedProviders() async {
    if(state.mostRequestedProviders.isNotEmpty) return state.mostRequestedProviders;
    final result = await mostRequestedProivders(NoParameters());
    return result.fold(
      (error) {
        return [];
      },
      (data) {
        emit(state.copyWith(mostRequestedProviders: data));
        return data;
      },
    );
  }

  Future<void> getSearchProviders(ProvidersParams params) async {
    initStates();
    emit(state.copyWith(searchState: BaseState.loading));
    final result = await allProvidersUseCase(params);

    result.fold(
      (error) => emit(state.copyWith(searchState: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(searchState: BaseState.loaded, providers: data));
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
