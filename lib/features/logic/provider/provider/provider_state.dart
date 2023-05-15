part of 'provider_cubit.dart';

class ProviderState extends Equatable {
  final BaseState state;
  final ProvidersModel? data;
  final ErrorModel? error;
  const ProviderState({
    this.state = BaseState.initial,
    this.data ,
    this.error,
  });

  ProviderState copyWith({
    BaseState? state,
    ProvidersModel? data,
    ErrorModel? error,
  }) {
    return ProviderState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state, data, error];
}
