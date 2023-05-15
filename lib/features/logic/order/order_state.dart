part of 'order_cubit.dart';

class OrderState extends Equatable {
  final BaseState state;
  final BaseState cancelState;
  final OrderModel? data;
  final ErrorModel? error;
  const OrderState({
    this.cancelState = BaseState.initial,
    this.state = BaseState.initial,
    this.data ,
    this.error,
  });

  OrderState copyWith({
    BaseState? cancelState,
    BaseState? state,
    OrderModel? data,
    ErrorModel? error,
  }) {
    return OrderState(
      cancelState: cancelState ?? this.cancelState,
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state, cancelState, data, error];
}
