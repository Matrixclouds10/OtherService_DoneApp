part of 'country_cubit.dart';

class CountryState extends Equatable {
  final BaseState state;
  final List<CountryModel> data;
  final CountryModel? countryModel;
  final ErrorModel? error;
  const CountryState({
    this.state = BaseState.initial,
    this.data = const [],
    this.countryModel,
    this.error,
  });

  CountryState copyWith({
    BaseState? state,
    List<CountryModel>? data,
    CountryModel? countryModel,
    ErrorModel? error,
  }) {
    return CountryState(
      state: state ?? this.state,
      data: data ?? this.data,
      countryModel: countryModel ?? this.countryModel,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state, data, error, countryModel];
}
