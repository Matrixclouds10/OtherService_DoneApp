part of 'create_order_cubit.dart';

class CreateOrderState extends Equatable {
  final BaseState state;
  final OrderModel? data;
  final ErrorModel? error;
  const CreateOrderState({
    this.state = BaseState.initial,
    this.data  ,
    this.error,
  });

  CreateOrderState copyWith({
    BaseState? state,
    OrderModel? data,
    ErrorModel? error,
  }) {
    return CreateOrderState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state, data, error];
}
