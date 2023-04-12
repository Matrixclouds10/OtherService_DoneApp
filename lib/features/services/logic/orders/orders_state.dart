part of 'orders_cubit.dart';

class OrdersState extends Equatable {
  final BaseState state;
  final List<OrderModel> data;
  final ErrorModel? error;
  const OrdersState({
    this.state = BaseState.initial,
    this.data = const [],
    this.error,
  });

  OrdersState copyWith({
    BaseState? state,
    List<OrderModel>? data,
    ErrorModel? error,
  }) {
    return OrdersState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state, data, error];
}
