import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/provider/data/models/subscription/subscription_model.dart';
import 'package:weltweit/features/provider/domain/usecase/subscription/subscription_usecase.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionUseCase subscriptionUseCase;
  SubscriptionCubit(
    this.subscriptionUseCase,
  ) : super(const SubscriptionState());

  Future<void> getSubscription() async {
    initStates();
    emit(state.copyWith(state: BaseState.loading));
    final result = await subscriptionUseCase(NoParameters());

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
