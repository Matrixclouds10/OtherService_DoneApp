import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/subscription/subscription_model.dart';
import 'package:weltweit/features/domain/usecase/provider_subscription/subscribe_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_subscription/subscribtions_usecase.dart';

part 'subscription_state.dart';

class SubscribtionCubit extends Cubit<SubscribtionState> {
  final SubscribtionUseCase subscribtionUseCase;
  final SubscribeUseCase subscribeUseCase;
  SubscribtionCubit(
    this.subscribtionUseCase,
    this.subscribeUseCase,
  ) : super(const SubscribtionState());

  Future<void> getSubscribtions() async {
    initStates();
    emit(state.copyWith(state: BaseState.loading));
    final result = await subscribtionUseCase(NoParameters());

    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(state: BaseState.loaded, data: data));
      },
    );
  }

  Future<BaseResponse> subscribe(int id, String method) async {
    initStates();
    emit(state.copyWith(subscribeState: BaseState.loading));
    final result = await subscribeUseCase(SubscribeParams(id: id, paymentMethod: method));

    return result.fold(
      (error) {
        return  Future.error(error);
      },
      (data) {
        emit(state.copyWith(subscribeState: BaseState.loaded));
        return data;
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
