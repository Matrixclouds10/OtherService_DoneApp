part of 'provider_cubit.dart';

class ProviderState extends Equatable {
  final BaseState state;
  final BaseState rateState;

  final ProvidersModel? data;
  final List<ProviderRateModel> dataRates;
  final ErrorModel? error;
  const ProviderState({
    this.state = BaseState.initial,
    this.rateState = BaseState.initial,
    this.data,
    this.dataRates = const [],
    this.error,
  });

  ProviderState copyWith({
    BaseState? state,
    BaseState? rateState,
    ProvidersModel? data,
    List<ProviderRateModel> dataRates = const [],
    ErrorModel? error,
  }) {
    return ProviderState(
      state: state ?? this.state,
      rateState: rateState ?? this.rateState,
      data: data ?? this.data,
      dataRates: dataRates,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state, data, error, dataRates , rateState];
}
