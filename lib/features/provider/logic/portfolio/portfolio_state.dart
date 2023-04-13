part of 'portfolio_cubit.dart';

class PortfoliosState extends Equatable {
  final BaseState state;
  final BaseState addState;
  final List<PortfolioModel>? data;
  final ErrorModel? error;
  final String? message;
  const PortfoliosState({
    this.state = BaseState.initial,
    this.data,
    this.error,
    this.message,
    this.addState = BaseState.initial,
  });

  PortfoliosState copyWith({
    BaseState? state,
    List<PortfolioModel>? data,
    ErrorModel? error,
    BaseState? addState,
    String? message,
  }) {
    return PortfoliosState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
      message: message ?? this.message,
      addState: addState ?? this.addState,
    );
  }

  @override
  List<Object?> get props => [state, data, addState, error, message];
}
