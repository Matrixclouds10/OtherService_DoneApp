part of 'orders_cubit.dart';

class OrdersState extends Equatable {
  final BaseState pendingState;
  final BaseState completedState;
  final BaseState cancelledState;
  final BaseState invoiceState;
  final InvoiceModel? invoiceData;
  final List<OrderModel> pendingData;
  final List<OrderModel> cancelledData;
  final List<OrderModel> completedData;
  final ErrorModel? error;
  const OrdersState( {
    this.completedState = BaseState.initial,
    this.invoiceState= BaseState.initial,
    this.cancelledState = BaseState.initial,
    this.pendingState = BaseState.initial,
    this.pendingData = const [],
    this.cancelledData = const [],
    this.completedData = const [],
    this.invoiceData,
    this.error,
  });

  OrdersState copyWith({
    BaseState? pendingState,
    BaseState? cancelledState,
    BaseState? completedState,
    BaseState? invoiceState,
    List<OrderModel>? pendingData,
    List<OrderModel>? cancelledData,
    List<OrderModel>? completedData,
    InvoiceModel? invoiceData,
    ErrorModel? error,
  }) {
    return OrdersState(
      invoiceState: invoiceState ?? this.invoiceState,
      invoiceData: invoiceData ?? this.invoiceData,
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
        invoiceData,
        invoiceState,
        completedData,
        error,
        completedState,
        cancelledState,
      ];
}
