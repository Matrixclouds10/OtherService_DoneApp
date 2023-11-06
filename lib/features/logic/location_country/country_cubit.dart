import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/services/local/storage_keys.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/location/country_model.dart';
import 'package:weltweit/features/domain/usecase/location/countries_usecase.dart';
import 'package:weltweit/features/domain/usecase/location/country_usecase.dart';

part 'country_state.dart';

class CountryCubit extends Cubit<CountryState> {
  final CountriesUseCase countriesUseCase;
  final CountryUseCase countryUseCase;
  CountryCubit(
    this.countriesUseCase,
    this.countryUseCase,
  ) : super(const CountryState());

  Future<void> getCountries() async {
    if (state.state == BaseState.loading) return;
    if (state.state == BaseState.loaded) return;
    emit(state.copyWith(state: BaseState.loading));
    final result = await countriesUseCase(NoParameters());

    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(state: BaseState.loaded, data: data));
      },
    );
  }

  Future<void> getCountry() async {
    AppPrefs appPrefs = getIt();
    int? countryId = appPrefs.get(PrefKeys.countryId, defaultValue: null);
    // ProfileUseCase profileUseCase = ProfileUseCase(repository: getIt());
    // if (state.countryModel != null) return;
    // Either<ErrorModel, UserModel> profileResult = await profileUseCase(NoParameters());
    // UserModel? userModel = profileResult.fold((l) => null, (r) => r);

    // if (userModel == null) return;
    // if (userModel.countryModel?.id == null) return;
    if (countryId == null) return;
    final result = await countryUseCase(countryId);

    result.fold(
      (error) => null,
      (data) {
        emit(state.copyWith(countryModel: data));
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
