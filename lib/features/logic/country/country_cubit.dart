import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/response/auth/user_model.dart';
import 'package:weltweit/features/data/models/response/country/country_model.dart';
import 'package:weltweit/features/domain/usecase/country/countries_usecase.dart';
import 'package:weltweit/features/domain/usecase/country/country_usecase.dart';
import 'package:weltweit/features/domain/usecase/profile/profile_read_usecase.dart';

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
    ProfileUseCase profileUseCase = ProfileUseCase(repository: getIt());
    if (state.countryModel != null) return;
    Either<ErrorModel, UserModel> profileResult = await profileUseCase(NoParameters());
    UserModel? userModel = profileResult.fold((l) => null, (r) => r);

    if (userModel == null) return;
    if (userModel.countryId == null) return;
    final result = await countryUseCase(userModel.countryId!);

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
