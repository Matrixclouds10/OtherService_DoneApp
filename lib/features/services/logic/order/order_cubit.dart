import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/services/data/models/response/order/order.dart';
import 'package:weltweit/features/services/domain/usecase/order_cancel/order_cancel_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/order/order_usecase.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderUseCase orderUseCase;
  final OrderCancelUseCase orderCancelUseCase;
  OrderCubit(
    this.orderUseCase,
    this.orderCancelUseCase,
  ) : super(const OrderState());

  Future<void> getOrder(int params) async {
    initStates();
    emit(state.copyWith(state: BaseState.loading));
    final result = await orderUseCase(params);

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

  Future<bool> cancelOrder({required int id, String reason = ""}) async {
    emit(state.copyWith(cancelState: BaseState.loading));
    Either<ErrorModel, BaseResponse> result = await orderCancelUseCase(OrderCancelParams(id: id, reason: reason));

    return result.fold(
      (error) {
        emit(state.copyWith(cancelState: BaseState.error, error: error));
        return false;
      },
      (data) {
        emit(state.copyWith(cancelState: BaseState.loaded));
        return true;
      },
    );
  }
}
