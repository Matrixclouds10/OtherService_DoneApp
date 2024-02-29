part of 'city_cubit.dart';

class CityState extends Equatable {
  final BaseState state;
  final List<CityModel> data;
  final CityModel? cityModel;
  final ErrorModel? error;
  const CityState({
    this.state = BaseState.initial,
    this.data = const [],
    this.cityModel,
    this.error,
  });

  CityState copyWith({
    BaseState? state,
    List<CityModel>? data,
    CityModel? cityModel,
    ErrorModel? error,
  }) {
    return CityState(
      state: state ?? this.state,
      data: data ?? this.data,
      cityModel: cityModel ?? this.cityModel,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state, data, error, cityModel];
}
