part of 'orders_cubit.dart';

class OrdersState extends Equatable {
  final BaseState pendingState;
  final BaseState completedState;
  final BaseState cancelledState;
  final List<OrderModel> pendingData;
  final List<OrderModel> cancelledData;
  final List<OrderModel> completedData;
  final ErrorModel? error;
  const OrdersState({
    this.completedState = BaseState.initial,
    this.cancelledState = BaseState.initial,
    this.pendingState = BaseState.initial,
    this.pendingData = const [],
    this.cancelledData = const [],
    this.completedData = const [],
    this.error,
  });

  OrdersState copyWith({
    BaseState? pendingState,
    BaseState? cancelledState,
    BaseState? completedState,
    List<OrderModel>? pendingData,
    List<OrderModel>? cancelledData,
    List<OrderModel>? completedData,
    ErrorModel? error,
  }) {
    return OrdersState(
      pendingState: pendingState ?? this.pendingState,
      cancelledState: cancelledState ?? this.cancelledState,
      completedState: completedState ?? this.completedState,
      pendingData: pendingData ?? this.pendingData,
      cancelledData: cancelledData ?? this.cancelledData,
      completedData: completedData ?? this.completedData,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        pendingState,
        pendingData,
        cancelledData,
        completedData,
        error,
        completedState,
        cancelledState,
      ];
}
