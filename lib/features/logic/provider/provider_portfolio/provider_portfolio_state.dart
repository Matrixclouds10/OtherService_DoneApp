part of 'provider_portfolio_cubit.dart';

class ProviderPortfolioState extends Equatable {
  final BaseState state;
  final List<PortfolioModel> data;
  final ErrorModel? error;
  const ProviderPortfolioState({
    this.state = BaseState.initial,
    this.data = const [],
    this.error,
  });

  ProviderPortfolioState copyWith({
    BaseState? state,
    List<PortfolioModel>? data,
    ErrorModel? error,
  }) {
    return ProviderPortfolioState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state, data, error];
}
