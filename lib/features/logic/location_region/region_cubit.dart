import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/data/models/location/region_model.dart';
import 'package:weltweit/features/domain/usecase/location/regions_usecase.dart';

part 'region_state.dart';

class RegionCubit extends Cubit<RegionState> {
  final RegionsUseCase regionsUseCase;
  RegionCubit(this.regionsUseCase) : super(const RegionState());

  Future<void> getRegions(int cityId) async {
    if (state.state == BaseState.loading) return;
    emit(state.copyWith(state: BaseState.loading));
    final result = await regionsUseCase(RegionsParams(cityId: cityId));

    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(state: BaseState.loaded, data: data, error: null));
      },
    );
  }

  void initStates() {
    emit(state.copyWith(
      state: BaseState.initial,
      error: null,
    ));
  }

  void reset() {
    emit(state.copyWith(
      state: BaseState.initial,
      error: null,
      data: null,
    ));
  }
}
