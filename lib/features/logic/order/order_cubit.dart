import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/domain/usecase/order/order_accept_usecase.dart';
import 'package:weltweit/features/domain/usecase/order/order_cancel_usecase.dart';
import 'package:weltweit/features/domain/usecase/order/order_finish_usecase.dart';
import 'package:weltweit/features/domain/usecase/order/order_rate_usecase.dart';
import 'package:weltweit/features/domain/usecase/order/order_usecase.dart';
import 'package:weltweit/features/data/models/order/order.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderUseCase orderUseCase;
  final OrderCancelUseCase orderCancelUseCase;
  final OrderAcceptUseCase acceptUseCase;
  final OrderRateUseCase rateUseCase;
  final OrderFinishUseCase finishUseCase;
  OrderCubit(
    this.orderUseCase,
    this.orderCancelUseCase,
    this.acceptUseCase,
    this.rateUseCase,
    this.finishUseCase,
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

  Future<bool> acceptOrder({required int id}) async {
    emit(state.copyWith(acceptState: BaseState.loading));
    Either<ErrorModel, BaseResponse> result = await acceptUseCase(OrderAcceptParams(id: id));

    return result.fold(
      (error) {
        emit(state.copyWith(acceptState: BaseState.error, error: error));
        return false;
      },
      (data) {
        emit(state.copyWith(acceptState: BaseState.loaded));
        return true;
      },
    );
  }

  Future<bool> finishOrder({required int id, required String? price}) async {
    emit(state.copyWith(finishState: BaseState.loading));
    Either<ErrorModel, BaseResponse> result = await finishUseCase(OrderFinishParams(
      id: id,
      price: price ?? "",
    ));

    return result.fold(
      (error) {
        emit(state.copyWith(finishState: BaseState.error, error: error));
        return false;
      },
      (data) {
        emit(state.copyWith(finishState: BaseState.loaded));
        return true;
      },
    );
  }

  Future<bool> rateOrder({required OrderRateParams params}) async {
    Either<ErrorModel, BaseResponse> result = await rateUseCase(params);
    return result.fold(
      (error) => false,
      (data) => true,
    );
  }
}
