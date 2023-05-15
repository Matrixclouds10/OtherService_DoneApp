import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/data/models/order/order.dart';
import 'package:weltweit/features/domain/usecase/create_order/create_order_usecase.dart';

part 'create_order_state.dart';

class CreateOrderCubit extends Cubit<CreateOrderState> {
  final CreateOrderUseCase createOrderUseCase;
  CreateOrderCubit(
    this.createOrderUseCase,
  ) : super(const CreateOrderState());

  Future<void> createOrder(CreateOrderParams params) async {
    initStates();
    emit(state.copyWith(state: BaseState.loading));
    final result = await createOrderUseCase(params);

    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(state: BaseState.loaded,  data : data));
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
