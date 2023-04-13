import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/services/data/models/response/provider/providers_model.dart';
import 'package:weltweit/features/services/domain/usecase/provider/provider/provider_usecase.dart';

part 'provider_state.dart';

class ProviderCubit extends Cubit<ProviderState> {
  final ProviderUseCase usecase;
  ProviderCubit(
    this.usecase,
  ) : super(const ProviderState());

  Future<void> getProvider(int id) async {
    initStates();
    emit(state.copyWith(state: BaseState.loading));
    final result = await usecase(id);

    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(state: BaseState.loaded,  data : data));
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
