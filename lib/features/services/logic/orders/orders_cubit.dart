import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/services/data/models/response/order/order.dart';
import 'package:weltweit/features/services/domain/usecase/orders/orders_usecase.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersUseCase ordersUseCase;
  OrdersCubit(
    this.ordersUseCase,
  ) : super(const OrdersState());

  Future<void> getPendingOrders({required bool typeIsProvider}) async {
    emit(state.copyWith(pendingState: BaseState.loading));
    final result = await ordersUseCase(OrdersParams(
      OrdersStatus.pending,
      typeIsProvider,
    ));

    result.fold(
      (error) => emit(state.copyWith(pendingState: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(pendingState: BaseState.loaded, pendingData: data));
      },
    );
  }

  Future<void> getCancelledOrders({required bool typeIsProvider}) async {
    emit(state.copyWith(cancelledState: BaseState.loading));
    final result = await ordersUseCase(OrdersParams(
      OrdersStatus.cancelled,
      typeIsProvider,
    ));

    result.fold(
      (error) => emit(state.copyWith(cancelledState: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(cancelledState: BaseState.loaded, cancelledData: data));
      },
    );
  }

  Future<void> getCompletedOrders({required bool typeIsProvider}) async {
    emit(state.copyWith(completedState: BaseState.loading));
    final result = await ordersUseCase(OrdersParams(
      OrdersStatus.completed,
      typeIsProvider,
    ));

    result.fold(
      (error) => emit(state.copyWith(completedState: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(completedState: BaseState.loaded, completedData: data));
      },
    );
  }

  void reset() {
    emit(state.copyWith(
      pendingState: BaseState.initial,
      cancelledState: BaseState.initial,
      completedState: BaseState.initial,
      error: null,
      cancelledData: null,
      completedData: null,
      pendingData: null,
    ));
  }
}
