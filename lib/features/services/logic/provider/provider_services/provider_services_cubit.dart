import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/services/data/models/response/services/service.dart';
import 'package:weltweit/features/services/domain/usecase/provider/services/services_usecase.dart';

part 'provider_services_state.dart';

class ProviderServicesCubit extends Cubit<ProviderServicesState> {
  final ProviderServicesUseCase useCase;
  ProviderServicesCubit(
    this.useCase,
  ) : super(const ProviderServicesState());

  Future<void> getProviderServices(int id) async {
    initStates();
    emit(state.copyWith(state: BaseState.loading));
    final result = await useCase(id);

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
