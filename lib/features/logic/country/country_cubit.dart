import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/response/country/country_model.dart';
import 'package:weltweit/features/domain/usecase/country/country_usecase.dart';

part 'country_state.dart';

class CountryCubit extends Cubit<CountryState> {
  final CountryUseCase countryUseCase;
  CountryCubit(
    this.countryUseCase,
  ) : super(const CountryState());

  Future<void> getCountry() async {
    if (state.state == BaseState.loading) return;
    if (state.state == BaseState.loaded) return;
    emit(state.copyWith(state: BaseState.loading));
    final result = await countryUseCase(NoParameters());

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
