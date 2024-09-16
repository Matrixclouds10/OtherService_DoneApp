part of 'order_cubit.dart';

class OrderState extends Equatable {
  final BaseState state;
  final BaseState cancelState;
  final BaseState acceptState;
  final BaseState finishState;
  final BaseState startGotoWayState;
  final OrderModel? data;
  final ErrorModel? error;
  const OrderState({
    this.cancelState = BaseState.initial,
    this.state = BaseState.initial,
    this.startGotoWayState = BaseState.initial,
    this.acceptState = BaseState.initial,
    this.finishState = BaseState.initial,
    this.data ,
    this.error,
  });

  OrderState copyWith({
    BaseState? cancelState,
    BaseState? acceptState,
    BaseState? finishState,
    BaseState? startGotoWayState,
    BaseState? state,
    OrderModel? data,
    ErrorModel? error,
  }) {
    return OrderState(
      cancelState: cancelState ?? this.cancelState,
      acceptState: acceptState ?? this.acceptState,
      startGotoWayState: startGotoWayState ?? this.startGotoWayState,
      finishState: finishState ?? this.finishState,
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state, cancelState,startGotoWayState, data, error, acceptState, finishState];
}
