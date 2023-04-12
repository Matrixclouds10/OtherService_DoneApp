part of 'order_cubit.dart';

class OrderState extends Equatable {
  final BaseState state;
  final OrderModel? data;
  final ErrorModel? error;
  const OrderState({
    this.state = BaseState.initial,
    this.data ,
    this.error,
  });

  OrderState copyWith({
    BaseState? state,
    OrderModel? data,
    ErrorModel? error,
  }) {
    return OrderState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state, data, error];
}
