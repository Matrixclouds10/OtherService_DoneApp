part of 'wallet_cubit.dart';

class WalletState extends Equatable {
  final BaseState state;
  final BaseState convertState;
  final List<WalletModel> data;
  final ErrorModel? error;
  const WalletState({
    this.state = BaseState.initial,
    this.convertState = BaseState.initial,
    this.data = const [],
    this.error,
  });

  WalletState copyWith({
    BaseState? state,
    BaseState? convertState,
    List<WalletModel>? data,
    ErrorModel? error,
  }) {
    return WalletState(
      state: state ?? this.state,
      convertState: convertState ?? this.convertState,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state, convertState,data, error];
}
