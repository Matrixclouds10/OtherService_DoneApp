import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/data/models/location/city_model.dart';
import 'package:weltweit/features/domain/usecase/location/cities_usecase.dart';

part 'city_state.dart';

class CityCubit extends Cubit<CityState> {
  final CitiesUseCase citiesUseCase;
  CityCubit(this.citiesUseCase) : super(const CityState());

  Future<void> getCities(int countryId) async {
    if (state.state == BaseState.loading) return;
    emit(state.copyWith(state: BaseState.loading));
    final result = await citiesUseCase(CitiesParams(countryId: countryId));

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
