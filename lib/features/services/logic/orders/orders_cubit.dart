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

  Future<void> getOrders() async {
    initStates();
    emit(state.copyWith(state: BaseState.loading));
    final result = await ordersUseCase(NoParameters());

    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(state: BaseState.loaded, data: data));
      },
    );
  }

  void initStates() {
    emit(state.copyWith(
      state: BaseState.initial,
      error: null,
    ));
  }
}
